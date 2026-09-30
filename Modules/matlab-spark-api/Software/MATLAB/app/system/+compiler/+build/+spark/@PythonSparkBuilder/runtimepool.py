
def synchronized(func):
    func.__lock__ = threading.Lock()
		
    def synced_func(*args, **kws):
        with func.__lock__:
            return func(*args, **kws)

    return synced_func

def i_frameStr(f, depth):
    if f is None:
        return ' ROCK BOTTOM '
    if depth <= 0:
        return ' VISIBLE LIMIT '
    co = f.f_code
    parent = f.f_back
    retStr = i_frameStr(parent, depth - 1) + ' => ' +  co.co_name

    return retStr

def frameStr(f):
    return i_frameStr(f, 10)


class RuntimePool:
    """This class is a wrapper for a pool of different runtimes.
    It will create a pool of N entries, where N is deduced from
    the number of processors on the node.
    It will only create the N entries if needed, i.e. the following
    cases:
    
    1. There is an entry in the pool -> This entry will be returned.
    2. There is no entry in the pool, but the N entries have not been
       created yet -> A new entry will be created, and the numberOfCreated
       variable will be increased.
    3. There is no entr in the pool, bot N entries have already been
       created -> The call will block, until an entry is available.

    The class takes an argument, a function from the generated python package,
    e.g. my.package.initialize_runtime
    """

    def __init__(self, initFunction):
        self.pool = queue.SimpleQueue()

        # Try to get cpu_count from os
        # This may have to be changed for virtual cores
        self.poolSize = os.cpu_count()
        if self.poolSize is None:
            self.poolSize = 4
        
        self.numCreated = 0

        # Initialize the runtime to run out-of process
        # initFunction((['-outproc']))
        initFunction(([]))

    @synchronized
    def showRuntimeStats(self, origStr):
        """Outputs some metrics on the pool. Only used if metrics are turned on.
           The str argument is printed for clarification."""
        print(f'### Pool stats {origStr}:', frameStr(inspect.currentframe()))
        print(f'###         pool: [{self.poolSize}, {self.pool.qsize()}, {self.numCreated}]  pid, ppid: {os.getpid()},{os.getppid()}')

        
    @synchronized
    def get(self):
        if (self.pool.qsize() > 0):
            return self.pool.get()
        
        # qsize is 0
        if self.numCreated < self.poolSize:
            self.numCreated = self.numCreated + 1
            return Wrapper()
        else:
            return self.pool.get()

    @synchronized
    def put(self, wrapper):
        self.pool.put(wrapper)

# End of RuntimePool
