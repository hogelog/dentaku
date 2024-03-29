package main

import (
	"fmt"
	"github.com/PaesslerAG/gval"
	"github.com/atotto/clipboard"
	"github.com/chzyer/readline"
	"io"
	"os"
	"os/user"
	"path/filepath"
	"strings"
)

func main() {
	usr, err := user.Current()
	if err != nil {
		panic(err)
	}
	configDir := filepath.Join(usr.HomeDir, ".config", "dentaku")
	err = os.MkdirAll(configDir, 0755)
	if err != nil {
		panic(err)
	}

	vars := map[string]interface{}{}

	rlConfig := &readline.Config{
		Prompt:            "dentaku> ",
		HistoryFile:       filepath.Join(configDir, "history"),
		HistorySearchFold: true,
	}
	rl, err := readline.NewEx(rlConfig)
	if err != nil {
		panic(err)
	}
	defer rl.Close()

	copyFunc := gval.Function("copy", func(args ...interface{}) (interface{}, error) {
		val := args[0].(float64)
		err := clipboard.WriteAll(fmt.Sprintf("%.2f", val))
		return val, err
	})

	for {
		line, err := rl.Readline()
		if err == io.EOF || line == "exit" {
			break
		} else if err != nil {
			panic(err)
		} else if line == "" {
			continue
		}

		value, err := gval.Evaluate(normalize(line), vars, copyFunc)
		if err != nil {
			fmt.Println(err)
			continue
		}

		fmt.Printf("%.2f\n", value)
	}
}

var exclude_chars = []string{
	",",
	"$",
	"¥",
}

func normalize(line string) string {
	for _, ch := range exclude_chars {
		line = strings.ReplaceAll(line, ch, "")
	}
	return line
}
