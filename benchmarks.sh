#!/bin/sh

echo "Queue benchmarks:"
for i in benchmarks/*queue*.pir; do
    parrot $i
done

echo "Stack benchmarks:"
for i in benchmarks/*stack*.pir; do
    parrot $i
done

echo "Array benchmarks:"
for i in benchmarks/*array.pir; do
    parrot $i
done

