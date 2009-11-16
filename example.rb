require File.dirname(__FILE__) + "/main"

terminal = Terminal.new(:scanner => Scanner.new)
terminal.add_price "A", 2
terminal.add_price "A", 1.75, 4
terminal.add_price "B", 12
terminal.add_price "C", 1.25
terminal.add_price "C", 1, 6
terminal.add_price "D", 0.15

%w(A B C D A B A A).each { |x| terminal.scan(x) }
puts terminal.total #32.4
terminal.clear_items!

%w(C C C C C C C).each { |x| terminal.scan(x) }
puts terminal.total #7.25
terminal.clear_items!

%w(A B C D).each { |x| terminal.scan(x) }
puts terminal.total #15.4


