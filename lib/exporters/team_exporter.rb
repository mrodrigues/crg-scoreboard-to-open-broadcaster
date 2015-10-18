require 'fileutils'

class TeamExporter
  def initialize(path, uri_root_for_logo)
    self.path = path
    self.uri_root_for_logo = uri_root_for_logo
  end

  def export(team)
    FileUtils.mkdir_p(path)
    name_file { |f| f << team.name }
    copy_logo(team.logo_path)
    score_file { |f| f << team.score }
    lead_jammer_file { |f| f << 'LEAD' if team.lead_jammer }
    team.positions.each do |position|
      description = [position.number, position.name].join(' - ')
      position_file(position.type) { |f| f << description }
    end
  end

  private

  def name_file(&block)
    file_for('name.txt', &block)
  end

  def score_file(&block)
    file_for('score.txt', &block)
  end

  def lead_jammer_file(&block)
    file_for('lead_jammer.txt', &block)
  end

  def position_file(type, &block)
    file_for("#{type}.txt", &block)
  end

  def file_for(name, &block)
    File.open("#{path}/#{name}", 'w') { |f| block.call(f) }
  end

  def copy_logo(logo_path)
    logo_uri = "#{uri_root_for_logo}/html/#{logo_path}"
    logo_filename = "#{path}/logo.jpg"
    FileUtils.cp(logo_uri, logo_filename)
  end

  attr_accessor :path, :uri_root_for_logo
end
