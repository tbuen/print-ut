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

	"github.com/nanu-c/qml-go"

	"github.com/tbuen/print-ut/app/backend"
)

type Printer struct {
	Discovery bool
	Name      string
}

var (
	printer Printer
	cancel  context.CancelFunc
	channel chan *backend.Printer
	model   *qml.Common
)

func Start(c *qml.Context) {
	c.SetVar("printer", &printer)
}

func (p *Printer) StartDiscovery(obj *qml.Common) {
	if p.Discovery {
		return
	}
	model = obj
	var err error
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
			fmt.Println("Received something:", prt)
			buf, err := json.Marshal(prt)
			if err != nil {
				fmt.Println(err)
				return
			}
			fmt.Println("Send this to qml:", string(buf))
			model.Call("add", string(buf))
		} else {
			fmt.Println("Channel closed")
			p.Discovery = false
			qml.Changed(p, &p.Discovery)
		}
	default:
	}
}
