# behavior3delphi
**behavior3delphi** is a [**Behavior3**](http://behavior3.com) client library for Delphi (Behavior Trees for Delphi) based on [**behavior3js**](https://github.com/behavior3/behavior3js/).

## Contents

### Core Classes

This library includes the following core structures

- **BehaviorTree**: the structure that represents a Behavior Tree
- **Blackboard**: represents a "memory" in an agent and is required to to run a `BehaviorTree`
- **Composite**: base class for all composite nodes
- **Decorator**: base class for all decorator nodes
- **Action**: base class for all action nodes
- **Condition**: base class for all condition nodes
- **Tick**: used as container and tracking object through the tree during the tick signal
- **BaseNode**: the base class that provide all common node features

### Nodes

**Composite Nodes**: 

- Sequence
- Priority
- MemSequence
- MemPriority


**Decorators**: 

- Inverter
- Limiter
- MaxTime
- Repeater
- RepeaterUntilFailure
- RepeaterUntilSuccess

**Actions**:

- Succeeder
- Failer
- Error
- Runner
- Wait

## Building

Either include all units (incl. those found in the `Actions/Composites/Core/Decorators` directories) or install and compile the `Behavior3Delphi.dpk` package (in the `\Package` folder) and set *Link with runtime packages* to *true* in the project options (*Packages -> Runtime Packages*) of your project.

## Copyright and license

Copyright 2016 by Dennis D. Spreen <dennis@spreendigital.de>. Code released under [the MIT license](https://github.com/Dennis1000/behavior3delphi/blob/master/LICENSE).