console.log('hello');

function changeRect() {
    var elem = d3.select(this),
        svg_width = svgContainer.attr('width'),
        svg_height = svgContainer.attr('height'),
        cycle = elem.attr('cycle');

    if (cycle == '1') {
        elem.transition()
            .attr('width', svg_width / 3)
            .attr('height', svg_height / 3)
            .attr('cycle', 2)
            .style('fill', 'red');
    } else if (cycle == '2') {
        elem.transition()
            .attr('width', svg_width / 4)
            .attr('height', svg_height / 4)
            .attr('cycle', 3)
            .style('fill', 'green');
    } else if (cycle == '3') {
        elem.transition()
            .attr('width', svg_width / 2)
            .attr('height', svg_height / 2)
            .attr('cycle', 1)
            .style('fill', 'blue');
    }
}


var svgContainer = d3.select('body').append('svg')
                      .attr('width', 400).attr('height', 300);

var rect = svgContainer.append('rect')
                       .attr('width', svgContainer.attr('width') / 2)
                       .attr('height', svgContainer.attr('height') / 2)
                       .attr('cycle', 1)
                       .style('fill', 'blue')
                       .on('click', changeRect);
