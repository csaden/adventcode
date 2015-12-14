/*
--- Day 11: Corporate Policy ---

Santa's previous password expired, and he needs help choosing a new one.

To help him remember his new password after the old one expires, Santa has
devised a method of coming up with a password based on the previous one.
Corporate policy dictates that passwords must be exactly eight lowercase
letters (for security reasons), so he finds his new password by incrementing
his old password string repeatedly until it is valid.

Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on.
Increase the rightmost letter one step; if it was z, it wraps around to a, and
repeat with the next letter to the left until one doesn't wrap around.

Unfortunately for Santa, a new Security-Elf recently started, and he has
imposed some additional password requirements:

Passwords must include one increasing straight of at least three letters,
like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't
count.

Passwords may not contain the letters i, o, or l, as these letters can be
mistaken for other characters and are therefore confusing.

Passwords must contain at least two pairs of letters, like aa, bb, or zz.

For example:

hijklmmn meets the first requirement (because it contains the straight hij)
but fails the second requirement requirement (because it contains i and l).

abbceffg meets the third requirement (because it repeats bb and ff) but fails
the first requirement.

abbcegjk fails the third requirement, because it only has one double letter
(bb).

The next password after abcdefgh is abcdffaa.

The next password after ghijklmn is ghjaabcc, because you eventually skip all
the passwords that start with ghi..., since i is not allowed.

Given Santa's current password (your puzzle input), what should his next
password be?
*/

/*
--- Part Two ---

Santa's password expired again. What's the next one?

*/


console.log(getNewPassword('hepxcrrq'));
console.log(getNewPassword(getNextPassword('hepxxyzz')));

function getNewPassword(password) {
    while (!isValidPassword(password)) {
        password = getNextPassword(password);
    }
    return password;
}

function getNextPassword(password) {
    let zString = password.match(/z+$/), zCount, aString = '';
    if (zString) {
        zCount = zString[0].length;
        for (var i=0; i<zCount; i++) {
            aString += 'a';
        }
        password = password.slice(0, -zCount-1) +  getNextLetter(password.substr(-zCount-1, 1)) + aString;
    } else {
        password = password.slice(0, -1) + getNextLetter(password.substr(-1));
    }
    return password;
}

function getNextLetter(char) {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    return letters[(letters.indexOf(char) + 1) % letters.length];
}

function isValidPassword(password) {
    return hasValidChars(password) && hasCharPair(password) &&
        hasThreeConsecutiveChars(password);
}

function hasValidChars(password) {
    return !(/(i|o|l)/g).test(password);
}

function hasCharPair(password) {
    return (/([a-z])\1[a-z]*([a-z])\2/).test(password);
}

function hasThreeConsecutiveChars(password) {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    for (var i=0, l=password.length; i<l-3; i++) {
        if (letters.indexOf(password.substring(i, i+3)) > -1) {
            return true;
        }
    }
    return false;
}
