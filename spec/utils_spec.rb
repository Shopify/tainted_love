RSpec.describe(TaintedLove::Utils) do
  include TaintedLove::Utils

  context 'proxy_method' do
    it 'replaces a method' do
      dummy_class = Class.new do
        def dummy
          'dummy'
        end
      end

      proxy_method(dummy_class, :dummy) do |*_args|
        raise 'proxy'
      end

      instance = dummy_class.new

      expect do
        instance.dummy
      end.to(raise_error('proxy'))
    end

    it 'can change the return value' do
      dummy_class = Class.new do
        def dummy
          'dummy'
        end
      end

      proxy_method(dummy_class, :dummy, true) do |return_value|
        return_value.taint + ' proxy'
      end

      instance = dummy_class.new
      return_value = instance.dummy

      expect(return_value.tainted?).to(eq(true))
      expect(return_value).to(eq('dummy proxy'))
    end
  end
end
