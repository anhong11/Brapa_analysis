#!/usr/bin/python

import re
import sys
import os
import os.path
import argparse
import string

def setup():
    parser = argparse.ArgumentParser(description='Convert plink2 format  into evec format')

    parser.add_argument('--bfile',dest='bfile',action='store')
    parser.add_argument('--eigenvec',dest='eigenvec',action='store',default="plink.eigenvec")
    parser.add_argument('--eigenval',dest='eigenval',action='store',default="plink.eigenval")
    parser.add_argument('--out',dest="out",action='store',required=True)

    args = parser.parse_args()

    if args.bfile:
        if args.eigenvec != "plink.eigenvec":
            sys.exit("Cannot specify --bfile and eigenvec file")
        if args.eigenval != "plink.eigenval":
            sys.exit("Cannot specify --bfile and eigenval file")
        args.fam="%s.fam"%args.bfile
        args.eigenvec = "%s.eigenvec"%args.bfile
        args.eigenval = "%s.eigenval"%args.bfile;


    return args


args=setup()


# Get eigenvalues if there are
eigenhead="# "
if os.path.exists(args.eigenval):
    eigenhead="#eigvals: "
    f = open(args.eigenval)
    
    for x in f:
        eigenhead = eigenhead + x.rstrip("\n")+" "
    f.close()


outf = open(args.out,"w")
outf.write("%s\n"%eigenhead)

eigf = open(args.eigenvec)

for vector in eigf:
    mm = re.search("^\s*(\S+)\s+(\S+)(.*)",vector)
    if not mm:
        sys.exit("Can't parse line <%s> in fam file\n"%args.fam)
    outf.write("%s:%s\t%s\tXXX\n"%(mm.group(1),mm.group(2),mm.group(3)))

eigf.close()
outf.close()
