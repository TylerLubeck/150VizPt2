console.log('hello');

function changeRect() {
    var elem = d3.select(this),
    svg_width = svgContainer.attr('width'),
    svg_height = svgContainer.attr('height'),
        cycle = elem.attr('cycle'),
        new_width = 0,
            new_height = 0,
            color = 'red'
                new_cycle = 0,
                new_msg = '';

    if (cycle == '1') {
        color = 'red';
        new_width = svg_width / 3;
        new_height = svg_height / 3;
        new_cycle = 2;
        new_msg = 'middle';
    } else if (cycle == '2') {
        color = 'green';
        new_width = svg_width / 4;
        new_height = svg_height / 4;
        new_cycle = 3;
        new_msg = 'small';
    } else if (cycle == '3') {
        color = 'blue';
        new_width = svg_width / 2;
        new_height = svg_height / 2;
        new_cycle = 1;
        new_msg = 'big';
    }
    elem.transition()
        .attr('width', new_width)
        .attr('height', new_height)
        .attr('cycle', new_cycle)
        .style('fill', color)
        .each("end", function() {
            setText(elem, new_msg);
        });
}


var svgContainer = d3.select('body').append('svg')
                     .attr('width', 400).attr('height', 300);

var rect = svgContainer.append('rect')
                       .attr('width', svgContainer.attr('width') / 2)
                       .attr('height', svgContainer.attr('height') / 2)
                       .attr('cycle', 1)
                       .style('fill', 'blue')
                       .on('click', changeRect);

var txt = svgContainer.append('text')
                      .attr('text-anchor', 'middle')
                      .attr('fill', 'white')

setText(rect, 'big');

function setText(elem, msg) {
    txt.transition().attr('x', elem.attr('width') / 2)
        .attr('y', elem.attr('height') / 2)
        .text(msg);
}
