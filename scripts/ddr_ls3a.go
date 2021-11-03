package main

import (
	"bufio"
	"encoding/binary"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func main() {
	f, err := os.OpenFile(os.Args[1], os.O_RDONLY, 0666)
	if err != nil {
		panic(err)
	}
	f.Seek(65184, 0)
	l := 0x3a0
	d := make([]uint64, l/8)
	dr := make([]uint64, l/8)
	err = binary.Read(f, binary.LittleEndian, d)
	if err != nil {
		panic(err)
	}
	err = binary.Read(f, binary.LittleEndian, dr)
	if err != nil {
		panic(err)
	}
	f.Close()

	lable := "MC0_DDR3_CTRL_0x"
	labler := "MC0_DDR3_RDIMM_CTRL_0x"

	f, err = os.OpenFile(os.Args[2], os.O_RDONLY, 0666)
	f1 := bufio.NewReader(f)
	for {
		l, err := f1.ReadString('\n')
		if err != nil {
			break
		}
		if regexp.MustCompile(lable).MatchString(l) {
			re := regexp.MustCompile("^"+lable + `([^:]+):\s+.dword\s+(\S+)`)
			repl := func(s string) string {
				p := re.FindStringSubmatch(s)
				i, _ := strconv.ParseUint(p[1], 16, 32)
				return lable + p[1] + fmt.Sprintf(": .dword 0x%016x", d[i/8])
			}
			l = re.ReplaceAllStringFunc(l, repl)
		} else if regexp.MustCompile(labler).MatchString(l) {
			re := regexp.MustCompile("^"+labler + `([^:]+):\s+.dword\s+(\S+)`)
			repl := func(s string) string {
				p := re.FindStringSubmatch(s)
				i, _ := strconv.ParseUint(p[1], 16, 32)
				return labler + p[1] + fmt.Sprintf(": .dword 0x%016x", dr[i/8])
			}
			l = re.ReplaceAllStringFunc(l, repl)
		}
		fmt.Print(l)
	}

}
