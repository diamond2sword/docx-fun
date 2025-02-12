#!/bin/bash

distro=debian
rootfs_dir=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs
env_dir=$rootfs_dir/$distro/root/unoserver
# declares env vars
env_vars="pid log port host cmd"
source <(echo -n $env_vars | xargs -d ' ' -I {} -n 1 echo {}_file=$env_dir/{})

docx=$1
[[ $docx =~ \.docx$ ]] || {
	echo must be a docx file
	exit 1
}

shifted=shifted-$docx
pdf=$docx.pdf
literal=literal-$docx
shifted_literal=shifted-$literal
literal_pdf=$literal.pdf

__unoconvert(){ unoconvert $1 $2 --port=$(cat $port_file) --input-filter="$3" --output-filter="$4"; }
docx2pdf(){ __unoconvert $1 $2 "MS Word 2007 XML" writer_pdf_Export; }
pdf2docx_unoserver(){ __unoconvert $1 $2 writer_pdf_import "MS Word 2007 XML"; }
pdf2docx_pymupdf(){ pd login debian -- /usr/bin/python3 $HOME/convert-pdf-to-docx.py $PWD/$1 $PWD/$2; }

docx2literal_unoserver()
{
	python set-margins.py $docx $shifted 0 2 0 2
	docx2pdf $shifted $pdf
	pdf2docx_unoserver $pdf $shifted_literal
	python set-margins.py $shifted_literal $literal 1 1 1 1
}

docx2literal_pymupdf()
{
	docx2pdf $docx $pdf
	pdf2docx_pymupdf $pdf $literal
}	

docx2literal_pymupdf
