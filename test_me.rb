class TestMe
    attr_accessor :num, :finalized

    def self.run_tests(times = 10)      
      (1..times).each { |num| TestMe.new(num).call }
    end

    def initialize(num)
        @num = num
    end

    def call
        obj = Object.new
        @finalized = false

        ObjectSpace.define_finalizer(obj, create_finalizer_func(self))

        obj = nil

        GC.start
        GC.compact
        
        raise "#{num}: Object was not finalized" if !@finalized
    rescue => err
        puts err
    end

    def create_finalizer_func(test_instance)
        -> (_object_id) do
          puts "#{test_instance.num}: Finalizing"
          test_instance.finalized = true
        end
    end
end
