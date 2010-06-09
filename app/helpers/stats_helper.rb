module StatsHelper
  def format_stat stat
    sprintf("%4.3f", stat).gsub("0.", ".")
  end
end
