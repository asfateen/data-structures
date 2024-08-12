AssignedJob = Struct.new(:worker, :started_at)

class JobQueue
  attr_reader :assigned_jobs
  def initialize(n_workers, jobs)
    @n = n_workers
    @jobs = jobs
    @finish_time = []
    @assigned_jobs = []
    (0...@n).each do |i|
      @finish_time << [i, 0]
    end
  end

  def sift_down(i)
    min_index = i
    left = 2 * i + 1
    right = 2 * i + 2
    if left < @n
      if @finish_time[min_index][1] > @finish_time[left][1]
        min_index = left
      elsif @finish_time[min_index][1] == @finish_time[left][1]
        if @finish_time[min_index][0] > @finish_time[left][0]
          min_index = left
        end
      end
    end

    if right < @n
      if @finish_time[min_index][1] > @finish_time[right][1]
        min_index = right
      elsif @finish_time[min_index][1] == @finish_time[right][1]
        if @finish_time[min_index][0] > @finish_time[right][0]
          min_index = right
        end
      end
    end
      unless min_index == i
        @finish_time[i], @finish_time[min_index] = @finish_time[min_index], @finish_time[i]
        sift_down(min_index)
      end
  end

  def nextWorker(job)
    root = @finish_time[0]
    next_worker = root[0]
    started_at = root[1]
    @assigned_jobs << AssignedJob.new(next_worker, started_at)
    @finish_time[0][1] += job
    sift_down(0)
  end
end

def assign_jobs(n_workers, jobs)
  job_queue = JobQueue.new(n_workers, jobs)
  jobs.each {|job| job_queue.nextWorker(job)}
  
  job_queue.assigned_jobs


end

def naive_assign_jobs(n_workers, jobs)
  result = []
  next_free_time = Array.new(n_workers, 0)

  jobs.each do |job|
    next_worker = (0...n_workers).min_by { |w| [next_free_time[w], w] }
    result << AssignedJob.new(next_worker, next_free_time[next_worker])
    next_free_time[next_worker] += job
  end

  result
end

if __FILE__ == $0
  n_workers, n_jobs = gets.split.map(&:to_i)
  jobs = gets.split.map(&:to_i)
  raise "Job count mismatch" unless jobs.size == n_jobs

  assigned_jobs = assign_jobs(n_workers, jobs)

  assigned_jobs.each do |job|
    puts "#{job.worker} #{job.started_at}"
  end
end
