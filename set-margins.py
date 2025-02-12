from docx.shared import Inches
from docx import Document

def set_margins(in_path, out_path, margins):
    doc = Document(in_path)
    for section in doc.sections:
        section.left_margin = margins[0]
        section.right_margin = margins[1]
        section.top_margin = margins[2]
        section.bottom_margin = margins[3]
    doc.save(out_path)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('in_path')
    parser.add_argument('out_path')
    parser.add_argument('margins_lrtb', type=float, nargs=4)
    args = parser.parse_args()
    set_margins(args.in_path, args.out_path, tuple(map(Inches, args.margins_lrtb)))
#    set_margins(**vars(parser.parse_args()))
