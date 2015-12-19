# Example of build a C program using smart-make

Main Smart Files
================

  * .tool
    Set the `TOOL` variable to tell which build tool is going to be used, `gcc` in this case. This is
    optional, but if it's absent, a explicit `TOOL=gcc` should be used on the `smart` command line.
  * smart
    The top level `smart` script for the main `example` program.
  * libfoo/smart
    A sub-level `smart` script to build `libfoo` sub module (a static library).

Build The Example
=================

{% highlight shell %}
$ ../../bin/smart
{% endhighlight %}

