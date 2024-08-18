+++
title = "Using Rust GATs to improve code and application performance"
date = "2023-08-22"
author = "Ukeje Goodness"
description = "Generic associated types in Rust can help us address some of the language’s limitations and improve performance."

[taxonomies]
tags = ["Rust", "Generics", "Improvements", "Technical"]
+++

---

_**[LogRocket](logrocket.com) made this piece possible. They provide AI-first session replay and analytics that shows
you what's wrong.**_





Generic associated types in Rust can help us address some of the language’s limitations and improve performance.

![Rust-GATs](/screenshot/Rust-Generic-Associated-Types.png)

Before GATs, Rust had associated types that enabled type association with traits. However, these were not directly tied
to the generic parameters of the implementing type. GATs enhance this concept by allowing associated types to depend on
the generic parameters of a trait.

GATs are useful in several scenarios, including the expression of iterator patterns and futures
and [asynchronous programming](https://blog.logrocket.com/a-practical-guide-to-async-in-rust/). Here, async libraries
can leverage GATs to define traits with associated types that accurately represent these dependencies and provide more
precise type information for async operations.

In this article, we will explore some ways we can use GATs in Rust to improve our code and application performance.

_Note that GATs became a stable Rust feature in v1.65. Since GATs were unstable before v1.65, you must
add `#![feature(generic_associated_types)]` to use GATs in earlier Rust versions._

## Getting started with Rust generic associated types

Rust traits can have associated types. However, before GATS, these associated types could not have their own generic
parameters. GATs lift this
restriction, [allowing associated types to be generic](https://blog.logrocket.com/understanding-rust-generics/#advanced-generic-types-rust-generic-associated-types)
and have a lifetime or type parameter.

Consider this example Rust trait with an associated type:

```rust
trait Producer {
    type Item;
    fn produce(&self) -> Self::Item;
}
```

The Producer trait has a `produce()` method that takes a reference to self and returns an item of type `Self::Item`.
The `Self::Item` syntax refers to the associated Item type defined within the trait.

With GATs, you can extend the trait to allow the associated type to have a generic parameter:

```rust
trait Producer {
    type Item<T>;
    fn produce<T>(&self, value: T) -> Self::Item<T>;
}
```

In this case, the Producer trait declares the produce method that takes a value of type `T` as a parameter and returns
an
item of type `Self::Item<T>`. The `syntax Self::Item<T>` refers to the associated type `Item<T>` associated with the
implementing type.

GATs form a cornerstone in Rust’s type system, offering a previously unattainable level of expressiveness. They allow
you to write more generic and reusable code, reducing boilerplate and enhancing code maintainability.

For instance, GATs enable you to define traits that return types with lifetimes tied to self, which previously wasn’t
possible. This capability is crucial for creating iterator traits that yield references to their items, amongst other
applications.

## When to use GATs in Rust

GATs are handy in scenarios where you need to express complex relationships between types and lifetimes in Rust. They
are especially useful when designing APIs that need to return types with lifetimes tied to self or when creating generic
data structures.

Consider a scenario where you’re creating a data structure that holds a collection of items and provides an iterator
over the items. Without GATs, you’ll have to use `Box<dyn Iterator>`, which incurs a runtime cost.

With GATs, you can express this naturally like so:

```rust
trait Iterable {
    type Item;
    type Iterator<'a>: Iterator<Item=&'a Self::Item> where Self: 'a;

    fn iter<'a>(&'a self) -> Self::Iterator<'a>;
}
```

Here, the `iterable` trait has two associated types — `Item` and `Iterator`. The Item associated type represents a type
of the
iterable elements, and the Iterator generic associated type represents the Iterator type that the `iter` method returns.

## Exploring use cases for GATs in Rust programs

There are several reasons and use cases for GATs in your everyday Rust programs, including avoiding unnecessary
allocations, enabling more efficient code generation, and improving code ergonomics. Let’s explore each of these in more
detail below.

## Avoiding unnecessary allocations

One everyday use for GATs is avoiding unnecessary allocations. You can prevent unnecessary allocations by defining a
trait for iterators that allocates memory when necessary.

Here’s a trait that defines an iterator that can iterate over the elements of a collection and allocates memory for used
elements:

```rust
#![feature(generic_associated_types)]

trait LendingIterator {
    type Item<'a>: 'a where Self: 'a;
    fn next<'a>(&'a mut self) -> Option<Self::Item<'a>>;
}

struct MyVec<T>(Vec<T>);

impl<T> LendingIterator for MyVec<T> where T: 'static {
    type Item<'a> = &'a T;

    fn next<'a>(&'a mut self) -> Option<Self::Item<'a>> {
        if self.0.is_empty() {
            None
        } else {
            Some(&self.0[0])
        }
    }
}

fn main() {
    let mut my_vec = MyVec(vec![1, 2, 3, 4, 5]);

    while let Some(item) = my_vec.next() {
        println!("{}", item);
        my_vec.0.remove(0);
    }
}
```

The Rust program above implements a custom iterator with GATs. The `LendingIterator` trait mimics the behavior of an
iterator.

The `type Item<'a>: 'a where Self: 'a;` line defines an associated type for the `LendingIterator` trait.

Meanwhile, `fn next<'a>(&'a mut self) -> Option<Self::Item<'a>>` is a signature for the next method required for types
that implement the `LendingIterator` trait.

The `MyVec` type implements the LendingIterator trait, and the main function creates a MyVec and prints the elements
before removing the elements from the vector.

Here’s the output from running the program:

![Rust-gats-output](/screenshot/Rust-gats-output.png)

## Enabling more efficient code generation

GATs can help with more efficient code generation. You can use GATS to define a trait for generic data structures that
then generate code for data structures that your program uses. Let’s explore an example to understand this concept
better.

Here’s a trait that defines a generic data structure for representing a tree:

```rust
trait Tree {
    type Item<'a>: 'a where Self: 'a;
    type Left<'a>: 'a where Self: 'a;
    type Right<'a>: 'a where Self: 'a;

    fn root(&self) -> &Self::Item<'_>;
    fn left(&self) -> Option<&Self::Left<'_>>;
    fn right(&self) -> Option<&Self::Right<'_>>;
}
```

The `Tree` trait represents the type of elements in the tree. The `root()` method returns a reference to the tree’s
root.
The `left()` and `right()` methods return references to the left and right subtrees of the tree, respectively.

The `Tree` trait doesn’t generate any code. Instead, it leaves the task to the types that implement the trait to decide
the methods to implement depending on the specific tree type being represented.

By using generic associated types, the Tree trait allows for flexibility in defining the types of items and left and
right subtrees within a tree data structure. The implementing types of the Tree trait will determine the specific types
for `Item`, `Left`, and `Right`.

This approach can help you generate more efficient code for various tree data structures.

## Improving the ergonomics of your code

You can use GATs to improve your code ergonomics in multiple ways. You can define a trait for generic builders that
eases the creation of complex data structures.

Here’s a trait that defines a generic builder for creating trees:
```rust

trait TreeBuilder<T> {
type Tree<'a>;

    fn root<'a>(self, value: T) -> Self::Tree<'a>;
    fn left<'a>(self, value: T) -> Self::Tree<'a>;
    fn right<'a>(self, value: T) -> Self::Tree<'a>;
    fn build<'a>(self) -> Self::Tree<'a>;

}
```

You can use the `TreeBuilder` trait to create complex trees easily. The trait provides methods for creating trees with one
root value, along with a `left` and `right` subtree. The `build` method returns a reference to the tree.

## Conclusion

In this article, we discussed generic associated types (GATs) in Rust. We explored some of their use cases and how you
can use them to improve the overall performance of your Rust applications.

GATs provide a more expressive and powerful way to model relationships between generic and associated types in Rust.
They enable more precise type information and help you implement advanced patterns and libraries in areas such as
iterator design, asynchronous programming, and type-level computations.

