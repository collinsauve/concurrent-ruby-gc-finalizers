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

        if @finalized
            puts log("Object finalized")
        else
            STDERR.puts "\e[31m#{log("Object NOT finalized")}\e[0m"
        end
    end

    def create_finalizer_func(test_instance)
        -> (_object_id) do
          puts test_instance.log("Finalizing")
          test_instance.finalized = true
        end
    end

    def log(message)
        time = Time.now.strftime("%Y-%m-%d_%H.%M.%S.%N")

        "[#{time}, #{num}, #{Thread.current.object_id}, #{Fiber.current.object_id}] #{message}"
    end
end
