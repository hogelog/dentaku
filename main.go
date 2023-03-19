package main

import (
	"fmt"
	"github.com/PaesslerAG/gval"
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

	for {
		line, err := rl.Readline()
		if err == io.EOF || line == "exit" {
			break
		} else if err != nil {
			panic(err)
		} else if line == "" {
			continue
		}

		value, err := gval.Evaluate(normalize(line), vars)
		if err != nil {
			fmt.Println(err)
			continue
		}

		fmt.Println(value)
	}
}

func normalize(line string) string {
	return strings.ReplaceAll(line, ",", "")
}
