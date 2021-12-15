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
	"github.com/phin1x/go-ipp"
)

func Print(file string, prt Printer) error {
	client := ipp.NewIPPClient(prt.IP, prt.Port, "", "", prt.TLS)
	_, err := client.PrintFile(file, "my-printer", map[string]interface{}{})
	return err
}
