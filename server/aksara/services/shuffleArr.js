module.exports = (array) => {
  let currentIndex = array.length;
  let temporaryValue;
  let randomIndex;
  const arrNew = array;

  while (currentIndex !== 0) {
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;
    temporaryValue = array[currentIndex];
    arrNew[currentIndex] = array[randomIndex];
    arrNew[randomIndex] = temporaryValue;
  }
  return arrNew;
};
