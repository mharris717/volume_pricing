require File.dirname(__FILE__) + "/main"

def make_scanner
  scanner = Scanner.new
  scanner.add_price "A", 2
  scanner.add_price "A", 1.75, 4
  scanner.add_price "B", 12
  scanner.add_price "C", 1.25
  scanner.add_price "C", 1, 6
  scanner.add_price "D", 0.15
  scanner
end

describe Product do
  before do
    @product = Product.new
    @product.add_price 1.5, 1
    @product.add_price 1.25,6
  end
  it '1 should use qty 1 price' do
    @product.price_for_quantity(1).should == 1.5
  end
  it '3 should use qty 1 price' do
    @product.price_for_quantity(3).should == 1.5*3
  end
  it '6 should use qty 6 price' do
    @product.price_for_quantity(6).should == 1.25*6
  end
  it '9 should use qty 6 price' do
    @product.price_for_quantity(9).should == 1.25*6 + 1.5*3
  end
end

describe Scanner do
  before do
    @scanner = make_scanner
  end
  it '1 A' do
    @scanner.price_for_quantity("A",1).should == 2
  end
  it '3 As should use qty 1 price' do
    @scanner.price_for_quantity("A",3).should == 2*3
  end
  it '7 Cs should use 6 qty and a 7th at 1.25 price' do
    @scanner.price_for_quantity("C",7).should == 1*6 + 1.25
  end
end

describe Terminal do
  before do
    @terminal = Terminal.new(:scanner => make_scanner)
  end
  it 'cart price should be correct' do
    @terminal.scan("A",2)
    @terminal.scan("C",7)
    @terminal.total.should == 2*2 + 1*6 + 1.25
  end
  it 'ABCDABAA should == 32.40' do
    %w(A B C D A B A A ).each { |x| @terminal.scan(x) }
    @terminal.total.should == 32.40
  end
  it 'CCCCCCC should == 7.25' do
    %w(C C C C C C C).each { |x| @terminal.scan(x) }
    @terminal.total.should == 7.25
  end
  it 'ABCD should == 15.40' do
    %w(A B C D).each { |x| @terminal.scan(x) }
    @terminal.total.should == 15.40
  end
end
