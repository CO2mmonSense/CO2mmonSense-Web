import { Controller } from "@hotwired/stimulus";
// This is the correct way to import the ECharts library
import * as echarts from "echarts";

export default class extends Controller {
  static values = {
    payload: Object,
  };

  connect() {
    const payload = this.payloadValue;
    // The line below was causing the error because 'echarts' was not imported correctly
    const chart = echarts.init(this.element);

    const option = {
      title: {
        text: `${payload.name} - PM2.5 Readings`,
        left: '1%'
      },
      tooltip: {
        trigger: 'axis'
      },
      grid: {
        left: '5%',
        right: '15%',
        bottom: '10%'
      },
      xAxis: {
        data: payload.data.map(item => item[0])
      },
      yAxis: {
        name: 'PM2.5 (µg/m³)'
      },
      toolbox: {
        right: 10,
        feature: {
          dataZoom: { yAxisIndex: 'none' },
          restore: {},
          saveAsImage: {}
        }
      },
      dataZoom: [
        { startValue: payload.data.length > 100 ? payload.data[payload.data.length - 100][0] : payload.data[0][0] },
        { type: 'inside' }
      ],
      visualMap: {
        top: 50,
        right: 10,
        pieces: [
          { gt: 0, lte: 12, color: '#93CE07' },
          { gt: 12, lte: 35, color: '#FBDB0F' },
          { gt: 35, lte: 55, color: '#FC7D02' },
          { gt: 55, lte: 150, color: '#FD0100' },
          { gt: 150, lte: 250, color: '#AA069F' },
          { gt: 250, color: '#AC3B2A' }
        ],
        outOfRange: { color: '#999' }
      },
      series: {
        name: 'PM2.5',
        type: 'line',
        data: payload.data.map(item => item[1]),
        markLine: {
          silent: true,
          lineStyle: { color: '#333' },
          data: [
            { yAxis: 12 },
            { yAxis: 35 },
            { yAxis: 55 },
            { yAxis: 150 },
            { yAxis: 250 }
          ]
        }
      }
    };

    chart.setOption(option);
  }
}