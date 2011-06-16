# Development Notes

## 2011 June 16th

I have decide to rewrite KO's API. After considerable thought
subsequent to attempted uses of KO on a few projects, I have
found that it has little to no advantage over other more readily
available solutions such as Minitest. It's one notable feature
of non needing an assertions framework, turns out to actually
be a FIT assertions framework in it's own right --something that
could be utilized by any framework. So I will probably spin that
off as such.

This leaves KO as little more than a rather schizophrenic test
"outliner", which in the scheme of things doesn't offer much. 
Other systems address the same need well enough. And even more
so when that system comes standard with Ruby, as is the case 
for `minitest/spec.rb` and its `describe`/`it` system.

So either KO can go the way of the dodo, or it finds new life
in another paradigm --which as it so happens I may have.
Cucumber is system that defines tests in the form of a strict
document syntax language called Gherkin. These documents
aren't Ruby code, but their own format. This leaves an opening
for a system that relects the Gherkin business language
but does so in pure Ruby. Another test framework called Steak
has attempoted to do this, but they have failed to truly
encompase Gherkin, and is rather a poor half-contrsucted outliner
itself.

For KO as Gherkin in Ruby, I arrived at a much more ... design.
Let's take Cucumber's homepage example and present it in KO's
potential new design (except we will actually do it right).

```ruby
  Feature "Addition" do
    So "to avoid silly mistakes"
    As "a math idiot"
    Be "told the sum of two numbers"

    Scenario "Add two numbers" do
      Given "I have a calculator"
      Given "I have entered 50 into the calculator"
      Given "I have entered 70 into the calculator"
      When  "I press add"
      Then  "the result should be 120 on the screen"
    end

    Given 'I have a calculator' do
      @calculator = Calculator.new
    end

    Given 'I have entered /\d+/ into the calculator' do |n|
      @calculator.push n.to_i
    end

    When 'I press add' do
      @result = calculator.add
    end

    Then 'the result should be /\d+/ on the screen" do |n|
      @result == n.to_i
    end
  end
```

