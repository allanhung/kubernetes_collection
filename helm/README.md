### Version
* hyphen ranges for closed intervals, where 1.1 - 2.3.4 is equivalent to >= 1.1 <= 2.3.4.
* wildcards x, X and *, where 1.2.x is equivalent to >= 1.2.0 < 1.3.0.
* tilde ranges (patch version changes allowed), where ~1.2.3 is equivalent to >= 1.2.3 < 1.3.0.
* caret ranges (minor version changes allowed), where ^1.2.3 is equivalent to >= 1.2.3 < 2.0.0

### Reference
* [nil pointer evaluating interface when upper level doesn't exist prevents usage of default function](https://github.com/helm/helm/issues/8026#issuecomment-848838425)
* [chart version](https://helm.sh/docs/topics/charts/)
* [Unexpected unclosed action in template clause](https://github.com/helm/helm/issues/7704#issuecomment-617636701)
* [3-way merge](https://devtron.ai/blog/changes-introduced-in-helm3/)
