package mod3

import (
	"fmt"
)

const (
	Name = "mod3"
)

func GetName() string {
	return Name
}

func Run() {
	fmt.Printf("Mod='%#+v'\n", Name)
}
