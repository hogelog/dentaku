package main

import (
	"bufio"
	"fmt"
	"os"
	"github.com/PaesslerAG/gval"
)

func main()  {
	vars := map[string]interface{}{}

	scanner := bufio.NewScanner(os.Stdin)
	for true {
		fmt.Print("> ")
		if !scanner.Scan() {
			break
		}
		text := scanner.Text()
		value, err := gval.Evaluate(text, vars)
		if err != nil {
		    fmt.Println(err)
		}
		fmt.Println(value)
	}
}
