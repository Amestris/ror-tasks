# Introduction to unit testing with Rspec #

Prerequisites:

* [RSpec core](http://rubydoc.info/gems/rspec-core/frames)
* [RSpec expectations](http://rubydoc.info/gems/rspec-expectations/frames)
* [Better specs](http://betterspecs.org/)
* [The better RSpec](http://blog.bandzarewicz.com/blog/2011/09/27/krug-the-perfect-rspec/)

## Introduction ##

This task covers the introduction to [Rspec](http://rspec.info/) - 
one of the most popular testing frameworks for Ruby. 
We will start with writing unit tests. Generally tests might be split into
several groups:
* unit tests
* integration tests
* acceptance tests
* performance tests
* regression tests

Each type of test has its own purpose, but in some cases the coverage of one
type intersects with another. So this taxonomy is not mutually exclusive.

### Unit tests ###

The unit tests are used to test behavior of a given class. Sometimes they are called
specs, since a well written unit-test defines the expected behavior of a given
class. As such unit tests should cover the public interface of the class, i.e.
all the methods that are publicly available. But in Test Driven Development
(TDD), the interface exposed by the class is a result of the tests, because
the tests are written prior to the implementation. As a result, the tests should
cover all aspects of the expected behavior of the class.

It should be noted, that although tests are very important for writing quality
code, they will never define the full behavior of the class. They are only an
approximation of the definition. As such they should check three types of
conditions:
* typical conditions
* unusual conditions
* error conditions

Usually developers only think about the first case - they check if the result of
a method is valid, if the arguments are valid, e.g. if a calculator returns 4
when it should add 2 to 2. But this is not enough - when writing quality code
we should also define how the class behaves, when the arguments are unusual and
when an error should be reported. So the proper test for a calculator covers 
also negative arguments (as an unusual condition) and what happens when we
divide by zero (as an error condition). 

In the context of Rails, we usually think of unit tests as tests covering the
model layer (in fact Rails imposes such an interpretation). However unit test
are all tests that check or define the behavior of a given class *in isolation*.
So the test written for a controller might be a unit test, assuming that it 
does not interact with the model layer (this will be covered in the following
tasks).

### Integration tests ###

The integration tests are used to test the behavior of the selected aspect of
the code when the classes interact with each other. In this sense it is an
opposite of unit tests, where the classes are tested in isolation. Integration
tests usually spot problems that arise in interaction between different parts
of the system, such as invalid arguments passed to the methods or invalid
sequences of calls. 

Because the integration tests usually involve external systems such as the
database or external web-services, they run much slower than the unit tests.
This is why unit tests are used to define the expected behavior of the system,
while integration tests are used mostly to spot the errors. In practice unit
tests are run whenever new piece of code is implemented, while integration
tests, depending on the complexity of the system, are run when the code is
passed to the shared repository or (at least part of them) on a server dedicated
only to run integration tests. This is particularly important for code which is
written by many developers, when many parallel changes are contributed to the
shared repository.

### Acceptance tests ###

The acceptance tests are tests developed to satisfy the exact requirements of
the client. For instance if the client delivers a specification of the system
behavior, this specification should be base for the acceptance tests. The most
important feature of acceptance tests is its language - it should be the client
language, not the language used by the developers. The acceptance tests should
be understandable for the client without clarification. As a result it should
cover sentences such as 'When I click the "Ok" button, a green message appears'.

This can be achieved using regular RSpec tests or test-frameworks dedicated for
writing acceptance tests, such as Cucumber. In Cucumber the definition of the
test is written in semi-structured English (or several other languages) and
follows Given-When-Then pattern, which allows to state the pre-conditions, the
conditions and the expected results of the system behavior. As such it allows
the non-technical participants of the project, to understand and even write the
specification. 

A different way of specifying acceptance tests is using the browser and
frameworks such as Selenium for recording the expected behavior of the system.
In the recording phase a user clicks through the interface and provides the
required data. She also defines the expected behavior of the system (such as
appearance of a text message, and the like. 
In the testing phase the test is run automatically by replying the interaction 
with the browser and by checking the defined conditions. 

Such tests are similar to the integration tests, since usually they cover many
classes of the system. The difference is that, they are taking the user
perspective, so in many cases they will not cover all invalid data that might be
supplied to the system. It should be also noted, that the acceptance tests run
with Selenium are very slow, so they are usually run only when the new release
of the system is prepared.

### Performance tests ###

### Regression tests ###