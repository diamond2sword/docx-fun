from pdf2docx import Converter

def convert_pdf_to_docx(in_path, out_path):
    cv = Converter(in_path)
    cv.convert(out_path)
    cv.close()

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('in_path')
    parser.add_argument('out_path')
    
    convert_pdf_to_docx(**vars(parser.parse_args()))
