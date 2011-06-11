# Toplevel Test module serves as the entry point for defining
# test cases and contexts. This provides a more readable interface
# than the KO module itself.
#
#   Test.case do
#     ...
#   end
#
module Test

  # Factory method to create a new KO::TestCase class.
  def self.case(desc, *tags, &block)
    c = Class.new(KO::TestCase, &block)
    c.desc(desc)
    c.tags(*tags)
    c
  end

  # Define a new context.
  def self.context(label=nil, &block)
    contexts[label] = Context.new(label, &block)
  end

  # Stores an index of contexts by label.
  def self.contexts
    @contexts ||= {}
  end

end

