/*
 * Copyright (C) 2021  Thomas Büning
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * print is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package app

import (
	"context"
	"encoding/json"
	"fmt"
	"path/filepath"

	"github.com/nanu-c/qml-go"

	"github.com/tbuen/print-ut/app/backend"
)

type UiData struct {
	Discovery bool
	Printing  bool
	Printer   string
	Filename  string
}

var (
	uiData       UiData
	model        *qml.Common
	cancel       context.CancelFunc
	scanChannel  chan *backend.Printer
	scanResult   map[int]backend.Printer
	printChannel chan error
	printer      backend.Printer
	filename     string
)

func Start(c *qml.Context) {
	c.SetVar("go", &uiData)
}

func (ui *UiData) Refresh() string {
	ui.refreshPrinterlist()
	return ui.refreshPrinting()
}

func (ui *UiData) StartDiscovery(obj *qml.Common) {
	if ui.Discovery {
		return
	}
	model = obj
	var err error
	scanResult = make(map[int]backend.Printer)
	scanChannel, cancel, err = backend.Discover()
	if err != nil {
		return
	}
	ui.Discovery = true
	qml.Changed(ui, &ui.Discovery)
}

func (ui *UiData) StopDiscovery() {
	if cancel == nil {
		return
	}
	cancel()
}

func (ui *UiData) refreshPrinterlist() {
	if !ui.Discovery {
		return
	}
	select {
	case prt, ok := <-scanChannel:
		if ok {
			fmt.Println("Found printer:", prt)
			scanResult[prt.ID] = *prt
			buf, err := json.Marshal(prt)
			if err != nil {
				return
			}
			model.Call("add", string(buf))
		} else {
			ui.Discovery = false
			qml.Changed(ui, &ui.Discovery)
		}
	default:
	}
}

func (ui *UiData) SelectPrinter(id int) {
	if prt, ok := scanResult[id]; ok {
		printer = prt
		ui.Printer = prt.Model
	} else {
		printer = backend.Printer{}
		ui.Printer = ""
	}
	qml.Changed(ui, &ui.Printer)
}

func (ui *UiData) SetFile(name string) {
	filename = name
	if name == "" {
		ui.Filename = ""
	} else {
		ui.Filename = filepath.Base(name)
	}
	qml.Changed(ui, &ui.Filename)
}

func (ui *UiData) Print() {
	if ui.Printing {
		return
	}
	printChannel = backend.Print(filename, printer)
	ui.Printing = true
	qml.Changed(ui, &ui.Printing)
}

func (ui *UiData) refreshPrinting() (msg string) {
	if !ui.Printing {
		return
	}
	select {
	case err, ok := <-printChannel:
		if ok {
			if err != nil {
				msg = err.Error()
			} else {
				msg = "Success!"
			}
		} else {
			ui.Printing = false
			qml.Changed(ui, &ui.Printing)
		}
	default:
	}
	return
}
