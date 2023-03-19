package main

import (
	"fmt"
	"github.com/PaesslerAG/gval"
	"github.com/chzyer/readline"
	"io"
	"strings"
)

func main() {
	vars := map[string]interface{}{}
	rl, err := readline.New("dentaku> ")
	if err != nil {
		panic(err)
	}
	defer rl.Close()

	for {
		line, err := rl.Readline()
		if err == io.EOF || line == "exit" {
			break
		} else if err != nil {
			panic(err)
		} else if line == "" {
			continue
		}

		line = strings.ReplaceAll(line, ",", "")

		value, err := gval.Evaluate(line, vars)
		if err != nil {
			fmt.Println(err)
			continue
		}

		fmt.Println(value)
	}
}
