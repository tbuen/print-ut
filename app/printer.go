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

	"github.com/nanu-c/qml-go"

	"github.com/tbuen/print-ut/app/backend"
)

type Printer struct {
	Discovery bool
	Name      string
}

var (
	printer         Printer
	cancel          context.CancelFunc
	channel         chan *backend.Printer
	model           *qml.Common
	scanResult      map[int]backend.Printer
	selectedPrinter backend.Printer
)

func (p *Printer) StartDiscovery(obj *qml.Common) {
	if p.Discovery {
		return
	}
	model = obj
	var err error
	scanResult = make(map[int]backend.Printer)
	channel, cancel, err = backend.Discover()
	if err != nil {
		return
	}
	p.Discovery = true
	qml.Changed(p, &p.Discovery)
}

func (p *Printer) StopDiscovery() {
	if cancel == nil {
		return
	}
	cancel()
}

func (p *Printer) RefreshList() {
	if !p.Discovery {
		return
	}
	select {
	case prt, ok := <-channel:
		if ok {
			scanResult[prt.ID] = *prt
			buf, err := json.Marshal(prt)
			if err != nil {
				return
			}
			model.Call("add", string(buf))
		} else {
			p.Discovery = false
			qml.Changed(p, &p.Discovery)
		}
	default:
	}
}

func (p *Printer) Select(id int) {
	if prt, ok := scanResult[id]; ok {
		selectedPrinter = prt
		p.Name = prt.Model
	} else {
		selectedPrinter = backend.Printer{}
		p.Name = ""
	}
	qml.Changed(p, &p.Name)
}
