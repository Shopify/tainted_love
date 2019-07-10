RSpec.describe(TaintedLove::Utils::Proxy) do
  it 'invokes proxy methods in the right order' do
    dummy_class = Class.new do
      attr_reader :called

      def dummy
        @called = true

        'dummy'
      end
    end

    proxy = TaintedLove::Utils::Proxy.new do
      def before
        @calls ||= []
        @calls << :before
      end

      def around
        # ensure method has not been called before
        @calls << :around_before if object.called.nil?

        yield # call the real method

        # ensure method has been called by yield
        @calls << :around_after if object.called == true
      end

      def after
        @calls << :after
      end

      def calls
        @calls
      end
    end

    proxy.apply(dummy_class, :dummy)

    instance = dummy_class.new

    instance.dummy

    expect(proxy.calls).to(eq([:before, :around_before, :around_after, :after]))
    expect(proxy.return_value).to(eq('dummy'))
    expect(instance.called).to(eq(true))
  end

  it 'can skip calling the real method and set the return value' do
    dummy_class = Class.new do
      attr_reader :called

      def dummy(x)
        @called = true

        'dummy'
      end
    end

    TaintedLove::Utils::Proxy.new(dummy_class, :dummy) do
      def around
        @return_value = 'my return value'
      end
    end

    instance = dummy_class.new

    expect(instance.dummy(1234)).to(eq('my return value'))
    expect(instance.called).to(eq(nil))
  end

  it 'can mutate arguments' do
    dummy_class = Class.new do
      def dummy(arr)
        arr.last
      end
    end

    TaintedLove::Utils::Proxy.new(dummy_class, :dummy) do
      def before
        arr = arguments[0]
        arr << 'my new value'
      end
    end

    instance = dummy_class.new
    arr = ['this would be the return value']

    expect(instance.dummy(arr)).to(eq('my new value'))
    expect(arr.size).to(eq(2))
  end

  it 'can replace arguments' do
    dummy_class = Class.new do
      def dummy(arg)
        arg
      end
    end

    TaintedLove::Utils::Proxy.new(dummy_class, :dummy) do
      def before
        @arguments = ['not the actual string']
      end
    end

    instance = dummy_class.new

    expect(instance.dummy('a string')).to(eq('not the actual string'))
  end
end
