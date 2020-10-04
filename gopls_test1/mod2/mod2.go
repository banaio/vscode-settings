package mod2

import (
	"fmt"
)

const (
	Name = "mod2"
)

func GetName() string {
	return Name
}

func Run() {
	fmt.Printf("Mod='%#+v'\n", Name)
}
