/*
 * Copyright (C) 2022  Thomas Büning
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
	"os"

	"github.com/phin1x/go-ipp"
)

var requestID int32

func Print(file string, prt Printer) chan error {
	ch := make(chan error)
	go func() {
		defer close(ch)

		i, err := os.Stat(file)
		if err != nil {
			ch <- err
			return
		}

		f, err := os.Open(file)
		if err != nil {
			ch <- err
			return
		}
		defer f.Close()

		requestID++
		req := ipp.NewRequest(ipp.OperationPrintJob, requestID)
		req.OperationAttributes[ipp.AttributePrinterURI] = "ipp://" + prt.IP + "/" + prt.Queue

		req.File = f
		req.FileSize = int(i.Size())

		http := ipp.NewHttpAdapter(prt.IP, prt.Port, "", "", false)

		uri := http.GetHttpUri("", prt.Queue)

		_, err = http.SendRequest(uri, req, nil)

		ch <- err
	}()
	return ch
}
