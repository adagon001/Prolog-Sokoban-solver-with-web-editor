var tiles = Array(
  '#', // Wall
  '@', // Player
  '+', // Player on goal
  '$', // Box
  '*', // Box on goal
  '.', // Goal
  ' ' // Floor
);

var tile = '#';

var minWidth = 2;
var minHeight = 2;

var levels = [
  [
    [' ', ' ', ' ', ' '],
    [' ', '#', '$', '$'],
    ['@', '#', '.', '.'],
  ],
  [
    ['#', '#', '#', ' ', '#', '#', '#'],
    ['#', '#', ' ', ' ', ' ', '#', '#'],
    ['#', ' ', ' ', ' ', ' ', ' ', '#'],
    [' ', ' ', '.', ' ', ' ', ' ', ' '],
    [' ', '@', '#', '$', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' '],
  ],
  [
    ['.', '@', ' ', ' '],
    ['$', '$', '$', '.'],
    ['.', ' ', ' ', ' '],
  ],
  [
    ['@', ' ', ' ', ' ', ' '],
    [' ', '#', ' ', '#', '$'],
    [' ', '#', '$', '#', '.'],
    [' ', ' ', ' ', ' ', '.'],
  ],
  [
    ['#', '#', '#', '#', '#'],
    ['@', '.', '$', ' ', ' '],
    ['#', '#', ' ', ' ', ' '],
  ],
  [
    [' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', '$', '$', '@', '$', '$', ' '],
    [' ', ' ', ' ', '.', ' ', ' ', ' '],
    [' ', ' ', '.', ' ', '.', ' ', ' '],
    [' ', ' ', ' ', '.', ' ', ' ', ' '],
  ],
  [
    ['.', '@', '$', '.'],
    ['$', ' ', '$', ' '],
    [' ', ' ', '.', ' '],
  ],
  [
    ['.', '$', ' ', '#', '#'],
    ['#', '#', ' ', '#', '#'],
    ['#', '#', ' ', '#', '#'],
    ['#', ' ', ' ', '$', '.'],
    ['#', '@', '#', ' ', '#'],
    ['.', '$', ' ', ' ', '#'],
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
    case '@':
      return 'player_floor';
      break;
    case '+':
      return 'player_goal';
      break;
    case '$':
      return 'box_floor';
      break;
    case '*':
      return 'box_goal';
      break;
    case '.':
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
      if (Level[i][n] === '@') return true;
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
      if (Level[cords.y][cords.x] == '+') {
        Level[cords.y][cords.x] = '.';
      } else {
        Level[cords.y][cords.x] = ' ';
      }
      cords = getNumbersAfterXAndY(args[1]);
      if (Level[cords.y][cords.x] == '.') {
        Level[cords.y][cords.x] = '+';
      } else {
        Level[cords.y][cords.x] = '@';
      }
      if (args.length === 3) {
        let cords = getNumbersAfterXAndY(args[2]);
        if (Level[cords.y][cords.x] == '.') {
          Level[cords.y][cords.x] = '*';
        } else {
          Level[cords.y][cords.x] = '$';
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
  stateStr = '[';
  goalStr = '[';
  var lvlRaw = '';

  for (i = 0; i < Level.length; i++) {
    for (n = 0; n < Level[i].length; n++) {
      if (i + 1 < Level.length)
        stateStr += ` top(x${n}y${i},x${n}y${i + 1}),`;
      if (n + 1 < Level[i].length)
        stateStr += ` right(x${n + 1}y${i},x${n}y${i}),`;
      switch (Level[i][n]) {
        case '@':
          stateStr += ` sokoban(x${n}y${i}),`;
          break;
        case ' ':
          stateStr += ` empty(x${n}y${i}),`;
          break;
        case '$':
          stateStr += ` box(x${n}y${i}),`;
          break;
        case '*':
          stateStr += ` storage(x${n}y${i}),`;
          stateStr += ` box(x${n}y${i}),`;
          goalStr += ` box(x${n}y${i}),`;
          break;
        case '.':
          stateStr += ` storage(x${n}y${i}),`;
          stateStr += ` empty(x${n}y${i}),`;
          goalStr += ` box(x${n}y${i}),`;
          break;
      }
      lvlRaw += Level[i][n];
    }
  }
  stateStr = stateStr.substring(0, stateStr.length - 1);
  goalStr = goalStr.substring(0, goalStr.length - 1);
  stateStr += ']';
  goalStr += ']';

  $('#levelcode_scl').text(stateStr);
}

$(document).ready(function () {
  buildLevel();
  makeLevelChooser();

  // $(document).live('mousedown', function() {
  // 	Downz = true;
  // });

  // $(document).live('mouseup', function() {
  // 	Downz = false;
  // });

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
    if (tile === '@' && isSokPlaced()) {
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
