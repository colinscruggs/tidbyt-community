// Package humanclock provides details for the Human Clock applet.
package humanclock

import (
	_ "embed"

	"tidbyt.dev/community/apps/manifest"
)

//go:embed human_clock.star
var source []byte

// New creates a new instance of the Human Clock applet.
func New() manifest.Manifest {
	return manifest.Manifest{
		ID:          "human-clock",
		Name:        "Human Clock",
		Author:      "colinscruggs",
		Summary:     "Easily readable clock",
		Desc:        "Displays time of day (and date) in an easy, digestible format.",
		FileName:    "human_clock.star",
		PackageName: "humanclock",
		Source:  source,
	}
}
