package mod1

import (
	"fmt"
)

const (
	Name = "mod1"
)

func GetName() string {
	return Name
}

func Run() {
	fmt.Printf("Mod='%#+v'\n", Name)
}
