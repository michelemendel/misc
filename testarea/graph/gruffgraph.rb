require 'gruff'

def drawgraph

    # Background bar graph
    g = Gruff::StackedBar.new
    g.title = "Sprint 2"
    # g.theme_37signals()
    g.theme = {
        :background_colors => %w(grey white),
        :marker_color => 'black',
        :colors => %w(yellow blue)
    }
    g.data("Started", [1, 2, 3, 4, 4, 3])
    g.data("Not Started", [4, 8, 7, 9, 8, 9])
    g.labels = {0 => '2003', 2 => '2004', 4 => '2005'}

    filename_bar = 'bar.png'
    g.write(filename_bar)


    # Final graph with line on bar
    line = Gruff::Line.new()
    line.colors = ['black']
    line.hide_legend = true
    line.hide_title = true
    line.hide_dots = true
    # line.hide_lines = true
    line.baseline_color = 'black'

    line.theme = {
        :background_image => filename_bar,
        :marker_color => 'transparent',
        :background_colors => nil
    }

    line.data("x", [10, 7, 5, 3, 1, 0])
    filename = 'bar_line.png'
    line.write(filename)
end

drawgraph
