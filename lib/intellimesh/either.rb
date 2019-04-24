# frozen_string_literal: true

module Intellimesh
  # Used to encapsulate a result that may return either a failure -
  # the 'left' value - or a result - the 'right' value.
  # Allow us to handle flow control that propogates failure without explicit
  # throwing of exceptions.
  #
  # This is primarily useful to avoid 'stairstepping' - or constant wrapped
  # calls to begin..rescue..end that propagate or don't depending on the result.
  class Either
    # The 'left', or 'bad' result.
    # Executing behaviour against this will propogate the error -
    # it won't actually run the code you supply.
    class Left
      attr_reader :value

      def initialize(val)
        @value = val
      end

      # Don't execute the provided block - propagate the error.
      #
      # @yield [L] The current value - ignored.
      # @return [Left<L>] Return self.
      def then
        self
      end

      # Don't execute the provided block - propagate the error.
      #
      # @yield [L] The current value - ignored.
      # @return [Left<L>] Return self.
      def fmap
        self
      end

      def right?
        false
      end

      def left?
        true
      end
    end

    # The 'right', or 'correct' result.
    # Executing behaviour against this will either take the new result,
    # or subsume it into an error.
    class Right
      attr_reader :value

      def initialize(val)
        @value = val
      end

      # Execute some code that returns an Either.
      #
      # @yield [R1] The current value.
      # @yieldreturn [Left<L>, Right<R2>]
      # @return [Left<L>, Right<R2>] The new Either result.
      def then
        yield value
      end

      # Execute some code that returns a value as a result of running the
      # block on our value.
      #
      # @yield [R1] The current value.
      # @yieldreturn [Right<R2>]
      # @return [Right<R2>] The new result to place in the Right.
      def fmap
        self.class.new(
          yield value
        )
      end

      def right?
        true
      end

      def left?
        false
      end
    end

    # Create a new 'right' instance.
    # Use for normal operations on values.
    #
    # @param val [R] the value
    # @return [Right<R>]
    def self.right(val)
      Right.new(val)
    end

    # Create a new 'left' instance.
    # Use this to capture failures or errors.
    #
    # @param val [L] the value
    # @return [Left<L>]
    def self.left(val)
      Left.new(val)
    end
  end
end
