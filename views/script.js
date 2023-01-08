var tiles = Array(
  '#', // Wall
  'S', // Player
  's', // Player on goal
  'C', // Box
  'c', // Box on goal
  'X', // Goal
  ' ' // Floor
);

var tile = '#';

var minWidth = 2;
var minHeight = 2;

var levels = [
  [
    [' ', ' ', ' ', ' '],
    [' ', '#', 'C', 'C'],
    ['S', '#', 'X', 'X'],
  ],
  [
    ['#', '#', '#', ' ', '#', '#', '#'],
    ['#', '#', ' ', ' ', ' ', '#', '#'],
    ['#', ' ', ' ', ' ', ' ', ' ', '#'],
    [' ', ' ', 'X', ' ', ' ', ' ', ' '],
    [' ', 'S', '#', 'C', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  ],
  [
    ['s', ' ', ' ', ' '],
    ['C', 'C', 'C', 'X'],
    ['X', ' ', ' ', ' '],
  ],
  [
    ['S', ' ', ' ', ' ', ' '],
    [' ', '#', ' ', '#', 'C'],
    [' ', '#', 'C', '#', 'X'],
    [' ', ' ', ' ', ' ', 'X'],
  ],
  [
    ['#', '#', '#', '#', '#'],
    ['S', 'X', 'C', ' ', ' '],
    ['#', '#', ' ', ' ', ' '],
  ],
  [
    ['X', 'S', 'C', 'X'],
    ['C', ' ', 'C', ' '],
    [' ', ' ', 'X', ' '],
  ],
  [
    ['X', 'C', ' ', '#', '#'],
    ['#', '#', ' ', '#', '#'],
    ['#', '#', ' ', '#', '#'],
    ['#', ' ', ' ', 'C', 'X'],
    ['#', 'S', '#', ' ', '#'],
    ['X', 'C', ' ', ' ', '#'],
  ],
];

var Level = levels[0];
var Width = Level[0].length;
var Height = Level.length;
var LevelBuilder = [];
var stateStr;
var goalStr;
var solution;

var x;
var y;

var Downz = false;

function charToTile(arg) {
  switch (arg) {
    case '#':
      return 'wall';
      break;
    case 'S':
      return 'player_floor';
      break;
    case 's':
      return 'player_goal';
      break;
    case 'C':
      return 'box_floor';
      break;
    case 'c':
      return 'box_goal';
      break;
    case 'X':
      return 'goal';
      break;
    case ' ':
      return 'floor';
      break;
  }
}

function buildLevel() {
  LevelBuilder = [];

  for (i = 0; i < Height; i++) {
    LevelBuilder[i] = [];
    for (n = 0; n < Width; n++) {
      var useTile = ' ';
      if (i in Level) {
        if (n in Level[i]) {
          useTile = Level[i][n];
        }
      }
      LevelBuilder[i][n] = useTile;
    }
  }

  Level = LevelBuilder;

  paintLevel();
  outputCode();
}

function makeLevelChooser() {
  const $select = $('<select class="form-select"></select>');
  $select.attr('id', 'pets');

  levels.forEach((item, i) => {
    const $option = $('<option></option>');
    $option.val(i);
    $option.text(`level${i}`);
    $select.append($option);
  });

  $('#levels').append($select);
}

function isSokPlaced() {
  for (i = 0; i < Level.length; i++) {
    for (n = 0; n < Level[i].length; n++) {
      if (Level[i][n] === 'S') return true;
    }
  }
  return false;
}

function getNumbersAfterXAndY(str) {
  const xRegex = /x(\d+)/;
  const yRegex = /y(\d+)/;
  const xMatch = str.match(xRegex);
  const yMatch = str.match(yRegex);
  return { x: parseInt(xMatch[1]), y: parseInt(yMatch[1]) };
}

async function showSolution() {
  await solution.forEach(({ args }, index) => {
    setTimeout(() => {
      let cords = getNumbersAfterXAndY(args[0]);
      if (Level[cords.y][cords.x] == 's') {
        Level[cords.y][cords.x] = 'X';
      } else {
        Level[cords.y][cords.x] = ' ';
      }
      cords = getNumbersAfterXAndY(args[1]);
      if (Level[cords.y][cords.x] == 'X') {
        Level[cords.y][cords.x] = 's';
      } else {
        Level[cords.y][cords.x] = 'S';
      }
      if (args.length === 3) {
        let cords = getNumbersAfterXAndY(args[2]);
        if (Level[cords.y][cords.x] == 'X') {
          Level[cords.y][cords.x] = 'c';
        } else {
          Level[cords.y][cords.x] = 'C';
        }
      }
      paintLevel();
      outputCode();
    }, 500 * index);
  });
}

function paintLevel() {
  var lvlStr = '';

  for (i = 0; i < Level.length; i++) {
    lvlStr += '<tr>';
    for (n = 0; n < Level[i].length; n++) {
      lvlStr +=
        '<td class="' +
        charToTile(Level[i][n]) +
        '" data-row="' +
        i +
        '" data-column="' +
        n +
        '"></td>';
    }
    lvlStr += '</tr>';
  }

  $('#level').html(lvlStr);
}

function rtrim(s) {
  var r = s.length - 1;
  while (r > 0 && s[r] == ' ') {
    r -= 1;
  }
  return s.substring(0, r + 1);
}

function outputCode() {
  stateStr = '';
  goalStr = '[';
  var lvlRaw = '';
  mapStr = '';
  sokStr = '';
  emptyStr = '';
  boxstr = '';

  for (i = 0; i < Level.length; i++) {
    for (n = 0; n < Level[i].length; n++) {
      if (i + 1 < Level.length)
        mapStr += ` top(x${n}y${i},x${n}y${i + 1}),`;
      if (n + 1 < Level[i].length)
        mapStr += ` right(x${n + 1}y${i},x${n}y${i}),`;
      switch (Level[i][n]) {
        case 'S':
          sokStr += ` sokoban(x${n}y${i}),`;
          break;
        case 's':
          sokStr += ` sokoban(x${n}y${i}),`;
          goalStr += ` box(x${n}y${i}),`;
          break;
        case ' ':
          emptyStr += ` empty(x${n}y${i}),`;
          break;
        case 'C':
          boxstr += ` box(x${n}y${i}),`;
          break;
        case 'c':
          boxstr += ` box(x${n}y${i}),`;
          goalStr += ` box(x${n}y${i}),`;
          break;
        case 'X':
          emptyStr += ` empty(x${n}y${i}),`;
          goalStr += ` box(x${n}y${i}),`;
          break;
      }
      lvlRaw += Level[i][n];
    }
  }
  stateStr = stateStr.substring(0, stateStr.length - 1);
  goalStr = goalStr.substring(0, goalStr.length - 1);
  goalStr += ']';
  mapStr = mapStr.substring(0, mapStr.length - 1);
  sokStr = sokStr.substring(0, sokStr.length - 1);
  emptyStr = emptyStr.substring(0, emptyStr.length - 1);
  boxstr = boxstr.substring(0, boxstr.length - 1);
  stateStr = `[[${mapStr}], ${sokStr}, [${boxstr}],[${emptyStr}]]`;

  $('#levelcode_scl').text(stateStr);
}

$(document).ready(function () {
  buildLevel();
  makeLevelChooser();

  $('td').live('mouseover', function () {
    if (Downz) {
      x = $(this).data('row');
      y = $(this).data('column');
      Level[x][y] = tile;
      buildLevel();
    }
  });

  $('td').live('mousedown', function () {
    x = $(this).data('row');
    y = $(this).data('column');
    if (tile === 'S' && isSokPlaced()) {
      alert('Player already placed!');
      return;
    }
    Level[x][y] = tile;
    buildLevel();
  });

  $('td').live('mouseup', function () {
    Downz = false;
  });

  $('#addColumn').click(function () {
    Width++;
    buildLevel();
  });

  $('#removeRow').click(function () {
    if (Height > 2) Height--;
    buildLevel();
  });

  $('#removeColumn').click(function () {
    if (Width > 2) Width--;
    buildLevel();
  });

  $('#addRow').click(function () {
    Height++;
    buildLevel();
  });
  $('#pets').change(function () {
    Level = levels[$(this).val()];
    Width = Level[0].length;
    Height = Level.length;
    buildLevel();
  });

  $('input[name=tile]').change(function () {
    tile = $(this).attr('value');
    $('label').removeAttr('class');
    $(this).parent().addClass('focus');
  });
  $('#myInput').change(function () {
    $.get(
      document.getElementById('myInput').files[0].name,
      function (data) {
        let lines = data.split(/\r?\n/);
        lines.forEach((line, i) => {
          lines[i] = lines[i].split('');
        });
        console.log(lines);
        Level = lines;
        Width = Level[0].length;
        Height = Level.length;
        buildLevel();
        paintLevel();
      }
    );
  });

  $('#solve').click(async function () {
    const req = $.ajax('http://localhost:9000/', {
      data: { bg: stateStr, gs: goalStr },
      type: 'POST',
    });
    const loader = await Swal.fire({
      title: 'Solving',
      didOpen: async () => {
        Swal.showLoading();
        try {
          const response = await req;
          $('#levelcode_raw').text(JSON.stringify(response.solution));
          console.log(JSON.stringify(response.solution));
          solution = response.solution;
          showSolution();
          swal.close();
        } catch (error) {
          console.log(error);
          Swal.showValidationMessage(error.responseText);
          Swal.hideLoading();
        }
      },
      showCancelButton: true,
      allowOutsideClick: () => !Swal.isLoading(),
    });
    if (loader.isDismissed) {
      req.abort();
      console.log(JSON.stringify(Level));
    }
  });
});
