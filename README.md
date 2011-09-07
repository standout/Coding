# Standout Coding Standards

In order to write readable, eloquent and coherent code we use the coding conventions listed in this file. If you don't agree with our standards, why not fork this and pull back your own preferences?

## General

### Indentation

Indentation should always be done with tabs. By doing that everyone working on a project could easily use their own favorite tab size (some prefer 2 spaces, some 4 spaces and so on).

### Alignment

In-code alignment should always be done with spaces. Since different persons have different tab size preferences, the alignment could easily break when it's done with tabs.

Example:

    # Alignment with spaces.
    method_call(arg,      arg,             arg)
    method_call(long_arg, long_arg,        arg)
    method_call(arg,      even_longer_arg, arg)

## Ruby

### Installation

Installation of new Rack or Rails applications should be done with Pow. Pow is a efficient way to handle your applications without unnecessary configuration.

### Indentation

Indentation in Ruby should follow the Ruby best practices. In this case it means we break the general rule about indentation. Use 2 space indent, no tabs.

## JavaScript

### Don't pollute the global scope

In JavaScript there are no namespaces, but it's easy to achieve just about the same effect with an object literal.

Example:

    var MyNamespace = {
        myVar: 'value',
        MyClass: function() {}
    };
    
    new MyNamespace.MyClass();

### Make a reference to "this"

In JavaScript, "this" always points to the current scope. In many cases this is probably not the way you want "this" to behave. Therefore, when declaring a class in JavaScript, always make a variable called "self" which maps to "this".

Example:

    var MyNamespace = {
        MyClass: function() {
            var self = this;
            
            self.myMethod = function() {
                $('#element').click(function() {
                    // this.myOtherMethod() wouldn't work as expected here.
                    self.myOtherMethod();
                });
            };
            
            self.myOtherMethod = function() {
                
            };
        }
    }

### Use the var keyword

## Markup

## CSS

For regular websites there is a css file called website_base.css that you could use as a starting point when creating new websites.

