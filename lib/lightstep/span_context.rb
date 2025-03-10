#frozen_string_literal: true

module LightStep
  # SpanContext holds the data for a span that gets inherited to child spans
  class SpanContext
    attr_reader :id, :trace_id, :trace_id16, :sampled, :baggage
    alias_method :sampled?, :sampled

    ZERO_PADDING = '0' * 16

    def initialize(id:, trace_id:, sampled: true, baggage: {})
      @id = id.freeze
      @trace_id16 = pad_id(trace_id).freeze
      @trace_id = truncate_id(trace_id).freeze
      @sampled = sampled
      @baggage = baggage.freeze
    end

    private

    def truncate_id(id)
      return id unless id && id.size == 32
      id[0...16]
    end

    def pad_id(id)
      return id unless id && id.size == 16
      "#{id}#{ZERO_PADDING}"
    end
  end
end
