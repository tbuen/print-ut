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
	"os"
	"path/filepath"

	"github.com/nanu-c/qml-go"
)

type File struct {
	Name string
}

var (
	file File
	data []byte
)

func (f *File) Set(name string) {
	data = data[:0]
	f.Name = ""
	defer qml.Changed(f, &f.Name)

	if name == "" {
		return
	}

	fh, err := os.Open(name)
	if err != nil {
		return
	}
	defer fh.Close()

	i, err := fh.Stat()
	if err != nil {
		return
	}

	data = make([]byte, i.Size())
	n, err := fh.Read(data)
	if err != nil {
		return
	}
	data = data[:n]

	f.Name = filepath.Base(name)
}
