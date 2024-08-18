+++
title = "Step up Your Go App Testing Game With the Testify Framework"
date = "2023-05-10"
author = "Ukeje Goodness"
description = "By using Testify in your Go projects, you can write tests that are simple and expressive, thereby ensuring that your code meets requirements with high quality"

[taxonomies]
tags = ["Golang", "Framework", "Testing", "Development", "Technical", "Self-help"]
+++

---

_**[Semaphore](https://semaphoreci.com/blog/testify-go) made this piece possible. They help product teams deliver software
with high standards of quality, security, and efficiency.**_



Testing is essential to the software development cycle, ensuring code integrity, reliability, and quality. As the complexity of software systems increases, testing becomes crucial to identify bugs and errors that may lead to system failure.
Go provides the `testing` package for testing however, writing tests with the package can be time-consuming and tedious. Fortunately, the Go ecosystem is home to sophisticated third-party packages like [Testify](https://github.com/stretchr/testify) that make test-related tasks more intuitive.

Testify is a popular testing toolkit for Go that provides a set of utilities and assertion functions that simplify testing. Testify extends the built-in `testing` package, allowing Go developers to write comprehensive tests confidently with features from assertions, mocks, suites, and others.

## Getting Started With the Testify Package

<img src="/screenshot/testify github stats preview.jpeg" alt="testify github stats preview">


Getting started with the `testify` package is easy. You’ll need to install the package in your Go project and write the tests in your Go test files.


First, initialize a new Go project with the `go mod init` command.

```shell
go mod init
```

Next, Run this command in the terminal of your project’s directory to install the `testify` package using the **`go get`** command.

```go
go get github.com/stretchr/testify
```

You can set up the Testify package in your Go project by importing the package into your test files.

```go
import "github.com/stretchr/testify"
```

You’ll need a Go test file to run your tests with the `testify` package. Typical Go test files end with the `_test.go` suffix appended to the file name where the functions you’re testing are located.

Run this command in your project’s working directory to create a Go test file for this tutorial.

```go
touch examples_test.go
```

You can run all the tests in your Go project with the `test` command. Adding the `-v` flag returns a verbose output of the test.

```go
go test -v
```

The `testify` package provides packages for multiple functionalities. You’ll use packages like `assert` and `mock` for assertions and mock testing along with other packages in the `testify` package.

## **Assertions with Testify**

Assertions are statements that validate certain conditions to test the behavior of a function or a piece of code. In Testify, the **`assert`** package provides various assertion functions for various test cases.

Here’s a function that adds two numbers and returns the sum and an error type. 

```go
package main

import "fmt"

// MyFunction returns the sum of two integers.
func MyFunction(a, b int) (int, error) {
	if a < 0 || b < 0 {
		return 0, fmt.Errorf("both arguments must be non-negative")
	}
	return a + b, nil
}
```

The `MyFunction` function takes in two integers. If any of the integers is a negative number on the function call , the function returns 0 and an error with the `fmt` package’s `Errorf` function.

Here’s how you can test the `MyFunction` function with the `testify` package’s `Equal`, `NoError`, and `Error` functions. 

```go
package main

import (
	"testing"
	"github.com/stretchr/testify/assert"
)

// In your Go test file
func TestMyFunction(t *testing.T) {
	// Test case 1: Positive inputs
	sum, err := MyFunction(2, 3)
	assert.Equal(t, 5, sum, "Sum of 2 and 3 is 5")
	assert.NoError(t, err, "There are no errors")

}

// In your Go test file
func TestMyFunction2(t *testing.T) {
	// Test case 2: One negative input
	sum, err := MyFunction(-2, 3)
	assert.Equal(t, 0, sum, "Sum of -2 and 3 is 0")
	assert.Error(t, err, "Error is not nil for negative input")

} 
```

The functions are typical Go test functions that take, in instances of the `*testing.T` type for the tests. 

The `TestMyFunction` test function calls the   `MyFunction` and uses the `Equal` function of the assert package to assert equality between the result and 5. The `NoError` function of the `assert` package asserts that a function returned no errors.     
Similarly, the `TestMyFunction2` test function calls the  `MyFunction` and uses the `Equal` function of the assert package to assert equality between the result and 0. The `Error` function of the `assert` package asserts that a function returned errors.   

Both test functions should pass since the `MyFunction` function returns the same result as the edge case in both scenarios.

<img src="/screenshot/result of assertions with Testify.png" alt="result of assertions with Testify">


## **Mocks with Testify**

Mocks are objects that simulate the behavior of real objects. Mocks are useful for testing interactions between different parts of a system. The **`mock`** package provides functionality for mock testing in the `testify` package. 

Here’s how you can create a simple mock object for testing.

```go
package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type mockCalculateArea struct {
	mock.Mock
}

func (m *mockCalculateArea) calculateArea(width int, height int) int {
	args := m.Called(width, height)
	return args.Int(0)
} 
```

After importing the `mock` and `assert` packages you declared the `mockCalculateArea` struct that embeds the `Mock` type from the `mock` package for the `calculateArea` function.

The `calculateArea` function implements the `mockCalculateArea` struct. The `args` variable holds the arguments passed to the mock object (the `width` and `height` arguments). Then the `Int` function takes in zero and extracts the first integer value from the  **`mock.Arguments`** object and returns the value as the result of the mock function.

Here’s how you can create mock objects for your test functions.

```go
// In your Go test file
func TestCalculateArea(t *testing.T) {
	// Create a mock object for the calculateArea function
	mockObj := new(mockCalculateArea)

	// Set up the expected return value
	mockObj.On("calculateArea", 5, 10).Return(50)

	// Call the function and check the result
	actualArea := mockObj.calculateArea(5, 10)
	assert.Equal(t, 50, actualArea, "The calculated area is incorrect")

	// Verify that the expected function call was made
	mockObj.AssertExpectations(t)
}
```

The `TestCalculateArea` function uses  the **`mockCalculateArea`** mock object to test the **`calculateArea`** function. The `new` function creates a new mock object of the `mockCalculateArea` type to simulate the behavior of the **`calculateArea`** function during the test.

The  `TestCalculateArea` function sets the expected return value of the **`calculateArea`** function using the `On` method of the mock object that takes in the expected input values for the function call as arguments (**`5`** and **`10`** in this case) and the expected return value (**`50`** in this case).
The `calculateArea` method calls the mock object with the same input values (**`5`** and **`10`**) as the expected function call. The actual return value of the function is stored in the **`actualArea`** variable.

The **`assert.Equal`** function verifies that the **`actualArea`** variable equals the expected return value (**`50`** in this case). If the actual value doesn’t match the expected value, the test fails, and the message is printed to the console.

Finally, the function calls the **`AssertExpectations`** method of the mock object to verify that the test made the expected function call during the test. If the function wasn’t called with the expected input values, the test fails.

<img src="/screenshot/result of mocking with testify.png" alt="result of mocking with testify">

## Test Suites with Testify

Test suites are collections of test cases designed to test the functionality of a specific software application, system, or component. Test suites typically include a set of test cases executed concurrently in a predefined order to achieve a specific testing goal.

You’ll need to define a struct that embeds the `Suite` type of the `suite` package to define test suits. The functions for the test suite will implement the struct type that embeds the `Suite` type.

```go
package main

import (
    "testing"

    "github.com/stretchr/testify/suite"
)

// Define a test suite struct that embeds suite.Suite
type MySuite struct {
    suite.Suite
    myVar int
}

// Define a SetupTest method that will be called before each test
func (s *MySuite) SetupTest() {
    s.myVar = 42
}

// Define a TearDownTest method that will be called after each test
func (s *MySuite) TearDownTest() {
    // cleanup code goes here
}

// Define individual test functions that will be run by the suite
func (s *MySuite) TestSomething() {
    // use s.Assert() or s.Require() to make assertions
    s.Assert().Equal(42, s.myVar)
}

// Define another test function
func (s *MySuite) TestSomethingElse() {
    s.myVar = 0
    s.Require().NotEqual(42, s.myVar)
}
```

The `MySuite` is the struct that embeds the `Suite` function for the test suite and the methods that implement the `MySuite` function define various test functions. 

You can run all the test suites with the `Run` function of the `suite` package. 

```go
// In your Go test file
func TestMySuite(t *testing.T) {
    suite.Run(t, new(MySuite))
}
```

The `run` function takes in the testing instance and an instance of the test suite struct and runs the methods that implement the struct.

<img src="/screenshot/result of test suites with testify.jpg" alt="result of test suites with testify">

## Test Hooks With Testify

Test hooks are special functions that execute before or after running tests. You can use test hooks to set up test fixtures, perform clean-up tasks or customize test behavior.

Here’s how you can implement test hooks in your Go programs.

```go

package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// In your Go test file
func TestExample(t *testing.T) {
	// Set up a "before" hook that will run before the test.
	t.Run("before", func(t *testing.T) {
		// Do some setup work here.
	})

	// Set up an "after" hook that will run after the test.
	t.Run("after", func(t *testing.T) {
		// Do some cleanup work here.
	})

	// Write the actual test code here.
	t.Run("test", func(t *testing.T) {
		// Use assertions to check the expected results.
		assert.Equal(t, 1+1, 2, "1+1 must be equal to 2")
	})
}
```

The `TestExample` function is the test function containing three nested test functions `before`, `after` and `tests` created with the `Run` method of the test instance that creates subtests that you can run independently from other tests. 

The **`before`** and **`after`** functions are test hooks that get executed before and after the **`test`** function, respectively. You can perform any operations inside these functions. In the **`test`** function, the Testify **`assert`** package makes assertions on the expected behavior of the code. In the previous example, we used the **`assert.Equal`** method to check that 1+1 equals 2.

## TDD vs. BDD with Testify

Recently, two popular testing methodologies have garnered popularity, namely Test Driven Development (TDD) and Behavior Driven Development (BDD). TDD and BDD are both used to ensure that software meets certain requirements and functions as intended.

TDD is a development approach where you write tests before writing the actual code. The idea behind TDD is to write small, testable units of code that meet the requirements of the software. After writing the tests, you write code that passes the tests. 

TDD is all about writing tests that drive the development of the code. This approach ensures that the code meets the requirements and is of high quality.

BDD, on the other hand, is a development approach focused on the behavior of the software. With BDD, you write tests that describe the expected behavior of the software. The tests are usually written in a specific syntax called Gherkin, designed to be effortlessly intuitive for both technical and non-technical stakeholders. BDD is all about describing the behavior of the software in a way that is understandable to everyone involved.

### **How Testify Supports TDD and BDD**

Testify supports both TDD and BDD testing methodologies. The suite of testing tools that the Testify package provides makes it easy to write tests that meet the requirements of the software.

For TDD, Testify provides tools for writing unit tests. These tools include assertions, mocks, and test suites. With Testify, developers can write tests that ensure that their code meets the requirements and behaves as expected.

For BDD, Testify provides a Gherkin-style syntax for writing tests, designed for easy readability by both technical and non-technical stakeholders. Testify's BDD tools also include assertions, mocks, and test suites. With Testify, you can write tests that describe the expected behavior of your software in a way that’s understandable for everyone involved.

| Topic | TDD with Testify | BDD with Testify |
| --- | --- | --- |
| Golang Testify Package | Provides various testing functions and assertions for writing tests in Go | Supports both TDD and BDD methodologies by providing assertion functions and the suite.Suite interface for  defining test suites |
| Purpose | Emphasizes on testing the functionality | Focuses on testing the behavior |
| Test Structure | You write test cases for each function | You write test cases for each behavior/scenario |
| Syntax | Uses assertions for checking the expected results | Uses natural language statements (Given-When-Then format) for describing test cases |
| User Involvement | Primarily for developers | Involves developers, testers, and business stakeholders |
| Collaboration | Minimal Collaboration | Engages collaboration between developers, testers, and business stakeholders |
| Test Documentation | Requires use of documentation to explain the code logic | You  create Documentation using natural language to describe code behaviour |

The table serves as a comparison between both methodologies and isn’t exhaustive. Testify provides functionality for both TDD and BDD and you can use the package for any of the approaches.

## Benefits of Using Testify

Most Go developers choose to Testify for testing their applications due to the many benefits, features, and functionalities that the package provides. 
Here’s an overview of the benefits you access when using the Testify package.

1. It allows you to define subtests for testing different scenarios within a single test function. Subtests make it easy to group related test cases together and improve test organization.
2. The library provides functionality for colorful and readable output formatting that can make it easier to identify and fix test failures. Outputs like helpful error messages, stack traces, and logs are all presented in an easy-to-read format.
3. Testify provides a wide range of assertion functions that you can use to write concise and clear test cases. The assertion functions writing tests that are both simple and expressive easy, reducing the amount of boilerplate code.
4. It includes a **`mock`** package for creating mock objects and functions for testing. The `mock` package is especially useful when testing code that has external dependencies, as it allows you to isolate the code from its dependencies. The **`mock`** package is easy to use, and the package can help you save a significant amount of time when writing tests.
## Testify vs GoConvey
To fully understand the benefits of using the Testify package, you can compare the package to [other popular testing packages](https://www.makeuseof.com/go-testing-packages-improved-productivity/) like the GoConvey package. 
[The GoConvey package](https://github.com/smartystreets/goconvey) is a testing framework that provides high-level API for defining test suites and test cases, including  a web-based user interface for viewing and analyzing test results

Here’s a comparison table comparing the Testify and GoConvey packages.

| Feature/Benefit | Testify | GoConvey |
| --- | --- | --- |
| Assertion Functions | Testify provides a wide range of assertion functions that you can use to write concise and clear test cases. These include functions like assert.Equal, assert.NotEqual, assert.True, assert.False, and many more. | GoConvey also provides a range of assertion functions like So, ShouldBeEqual, ShouldNotBeEmpty, and others, but the list of assertion functions isn’t as extensive as Testify. |
| Mocking | Testify provides a mock package that you can use to create mock objects and functions for testing. | GoConvey does not provide built-in mocking capabilities. |
| Suite Setup and Teardown | Testify allows for set up and tear down test suite fixtures, which can save you time and reduce code duplication. | GoConvey does not have built-in support for test suite setup and teardown. |
| Output Formatting | Testify provides colorful and readable output formatting that’s useful for identifying and fixing test failures. | GoConvey's output is less visually appealing and can be harder to read. |

Testify provides many benefits beyond the standard Go testing package, including a wide range of assertion functions, built-in mocking, test suite setup and teardown, subtests, and better output formatting. While GoConvey also provides some of these features, Testify has a more extensive list of assertion functions and built-in mocking capabilities, making the package a more powerful testing tool.

## Conclusion

You’ve learned the importance of testing and the limitations of using the standard Go `testing` package and explored Testify's assertion functions, mock testing functionalities, and test suites, learned about TDD and BDD and how Testify supports the testing methodologies, compared Testify and GoConvey packages and highlighted the advantages of using Testify. 

On using Testify in your Go projects, you can write tests that are simple and expressive, thereby ensuring that your code meets the requirements with high quality.
