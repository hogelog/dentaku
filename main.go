package main

import (
	"fmt"
	"github.com/PaesslerAG/gval"
	"github.com/chzyer/readline"
)

func main() {
	vars := map[string]interface{}{}

	rl, err := readline.New("> ")
	if err != nil {
		panic(err)
	}
	defer rl.Close()

	for {
		text, err := rl.Readline()
		if err != nil {
			break
		}
		value, err := gval.Evaluate(text, vars)
		if err != nil {
			fmt.Println(err)
		}
		fmt.Println(value)
	}
}
