module StatsHelper
  # format float numbers for display in Stats app
  # cuts off leading zero, but leaves a 1 if a stat has it
  def format_stat stat
    sprintf("%4.3f", stat).gsub("0.", ".")
  end
end
