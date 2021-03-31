package main

import (
	"encoding/json"
	"fmt"
	"github.com/antonmedv/expr"
)

type Claims struct {
	Groups []string `json:"groups,omitempty"`
}

func jsonify(v interface{}) (map[string]interface{}, error) {
	data, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	x := make(map[string]interface{})
	return x, json.Unmarshal(data, &x)
}

func main() {
	claims := &Claims{Groups: []string{"group1", "group2"}}
	v, _ := jsonify(claims)
	rule := "'group1' in groups or 'group2' in groups"
	result, err := expr.Eval(rule, v)
	if err != nil {
		fmt.Printf("failed to evaluate rule: %v\n", err)
	}
	fmt.Printf("%v", result)
}
