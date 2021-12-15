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

package backend

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/grandcat/zeroconf"
)

type Printer struct {
	ID    int    `json:"id"`
	Model string `json:"model"`
	IP    string `json:"ip"`
}

var id int

func Discover() (chan *Printer, context.CancelFunc, error) {
	resolver, err := zeroconf.NewResolver(nil)
	if err != nil {
		return nil, nil, err
	}
	printers := make(chan *Printer)

	entries := make(chan *zeroconf.ServiceEntry)
	go func(results <-chan *zeroconf.ServiceEntry) {
		for entry := range results {
			fmt.Println("Instance: ", entry.ServiceRecord.Instance)
			fmt.Println("Service:  ", entry.ServiceRecord.Service)
			fmt.Println("Domain:   ", entry.ServiceRecord.Domain)
			fmt.Println("HostName: ", entry.HostName)
			fmt.Println("Port:     ", entry.Port)
			fmt.Println("Text:     ", entry.Text)
			fmt.Println("TTL:      ", entry.TTL)
			fmt.Println("AddrIPv4: ", entry.AddrIPv4)
			fmt.Println("AddrIPv6: ", entry.AddrIPv6)
			fmt.Println()

			model := entry.ServiceRecord.Instance
			for _, t := range entry.Text {
				if strings.HasPrefix(t, "ty=") {
					model = strings.TrimPrefix(t, "ty=")
					break
				}
			}
			id++
			printers <- &Printer{id, model, entry.AddrIPv4[0].String()}
		}
	}(entries)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*120)

	go func() {
		err = resolver.Browse(ctx, "_ipp._tcp", "local.", entries)
		if err != nil {
			return
		}
		<-ctx.Done()
		close(printers)
	}()

	return printers, cancel, nil
}
