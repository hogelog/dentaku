package main

import (
	"fmt"
	"os"
	"bufio"
)

func main()  {
	scanner := bufio.NewScanner(os.Stdin)
	for true {
		fmt.Print("> ")
		if !scanner.Scan() {
			break
		}
		text := scanner.Text()
		fmt.Println(text)
	}
}
