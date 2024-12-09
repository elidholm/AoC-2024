import { readFileSync } from "fs";

type Rule = [string, string];
type Update = string[];

const solution = processInput(`${__dirname}/input.txt`);
console.log(solution);

function readLines(inputFilePath: string) {
    const input = readFileSync(inputFilePath, 'utf-8');
    return input.replace(/\r\n/g, '\n').split('\n');
}

function processInput(inputFilePath: string) {
    const { rules, updates } = parseInput(readLines(inputFilePath));
    const correctUpdates = updates.filter(update => isUpdateCorrect(update, rules));

    return {
        part1: sumMiddleElements(correctUpdates),
    };
}

function parseInput(inputLines: string[]): { rules: Rule[], updates: Update[] } {
    return inputLines.reduce(
        (acc, line) => {
            if (line.includes('|')) {
                acc.rules.push(line.split('|') as Rule);
            } else if (line.includes(',')) {
                acc.updates.push(line.split(',') as Update);
            }
            return acc;
        },
        { rules: [], updates: [] }
    );
}

function isUpdateCorrect(update: Update, rules: Rule[]): boolean {
    return rules.every(rule => isRuleSatisfied(update, rule));
}

function isRuleSatisfied(update: Update, [firstPage, secondPage]: Rule): boolean {
    const firstPageIdx = update.indexOf(firstPage);
    const secondPageIdx = update.indexOf(secondPage);

    // If either page is missing, we can assume the rule is satisfied.
    if (firstPageIdx === -1 || secondPageIdx === -1) {
        return true;
    }

    return firstPageIdx < secondPageIdx;
}

function getMiddle<T>(array: T[]): T {
    return array[Math.floor(array.length / 2)];
}

function sumMiddleElements(updates: Update[]): number {
    return updates
        .map(update => getMiddle(update))
        .reduce((sum, pageNumber) => sum + parseInt(pageNumber, 10), 0);
}
