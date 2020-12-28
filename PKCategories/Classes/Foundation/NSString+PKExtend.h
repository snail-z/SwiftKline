//
//  NSString+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PKExtend)

/**
* @brief 检查字符串是否不为空
*
* @return YES/NO (当字符串为nil, @"", @"  ", @"\n" 将返回NO)
*/
- (BOOL)pk_isNotEmpty;

/**
 * @brief 从字符串起始处提取子串到某个位置结束
 *
 * @return 返回子字符串 (nil, @"", @"  ", @"\n" 将返回@"")
 */
- (NSString *)pk_frontSubstringToIndex:(NSUInteger)toIndex;

/**
 * @brief 从字符串某个位置起提取子串到末尾结束
 *
 * @return 返回子字符串 (nil, @"", @"  ", @"\n" 将返回@"")
 */
- (NSString *)pk_backSubstringFromIndex:(NSUInteger)fromIndex;

/** 将字符串中的首字符删除，并返回一个新字符串 */
- (NSString *)pk_deleteFirstCharacter;

/** 将字符串中的末尾字符删除，并返回一个新字符串 */
- (NSString *)pk_deleteLastCharacter;

/** 去除字符串中的所有空白符 */
- (NSString *)pk_trimmingAllWhitespace;

/** 仅去除字符串中的首尾空白符 */
- (NSString *)pk_trimmingWhitespace;

/** 仅去除字符串中的换行符和首尾空白符 */
- (NSString *)pk_trimmingNewlineAndWhitespace;

/**
 * @brief 去除字符串中的特殊字符
 *
 * @param aString  需要去除的字符集，如 @"^• -\|~＜＞$€'@#$"
 * @return 返回过滤后的字符串
 */
- (NSString *)pk_trimmingWithCharactersInString:(NSString *)aString;

/** 将特殊URL字符串编码转换 (如包含中文的URL编码) */
- (nullable NSString *)pk_stringByURLQueryAllowedEncode;

/** 将字符串以URL编码, 编码格式为UTF8 */
- (nullable NSString *)pk_stringByURLEncode;

/**
 * @brief 通过NSNumericSearch比较字符串大小 (按照字符串里的数字为依据，算出顺序，如 2.9.txt < 7.txt < 9.25.txt)
 *
 * @return YES/NO (常用于版本号比较，当self > other时返回YES，反之为NO)
 */
- (BOOL)pk_isGreaterThanByNumericSearchCompare:(NSString *)other;

/**
 *  将字符串转换成NSData类型
 *
 *  @return NSData or Nil
 */
@property (nonatomic, strong, readonly, nullable) NSData *pk_dataValue;

/**
 Returns NSMakeRange(0, self.length).
 */
@property (nonatomic, assign, readonly) NSRange pk_rangeOfAll;

/**
 *  将字符串转换成json对象(NSDictionary或NSArray)，如果出现错误则返回nil
 *
 *  @return json对象或nil
 */
 - (nullable id)pk_jsonValueDecoded;

/**
 *  @brief 计算文本
 *
 *  @param font          字体大小
 *  @param size          限制尺寸
 *  @param lineBreakMode 换行模型 NSLineBreakMode
 *  NSLineBreakByCharWrapping; 以字符为显示单位显示，后面部分省略不显示
 *  NSLineBreakByClipping; 剪切与文本宽度相同的内容长度，后半部分被删除
 *  NSLineBreakByTruncatingHead; 前面部分文字以……方式省略，显示尾部文字内容
 *  NSLineBreakByTruncatingMiddle; 中间的内容以……方式省略，显示头尾的文字内容
 *  NSLineBreakByTruncatingTail; 结尾部分的内容以……方式省略，显示头的文字内容
 *  NSLineBreakByWordWrapping; 以单词为显示单位显示，后面部分省略不显示
 *
 *  @return 返回文本所对应的视图大小
 */
- (CGSize)pk_sizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
            lineBreakMode:(NSLineBreakMode)lineBreakMode;

/** 计算文本大小 (约束size) */
- (CGSize)pk_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/** 计算文本高度 (约束宽度) */
- (CGFloat)pk_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/** 计算文本宽度 (约束高度) */
- (CGFloat)pk_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

@end


@interface NSString (PKHash)

/*** 将字符串进行MD5摘要计算 */
- (nullable NSString *)pk_md5String;

@end


@interface NSString (PKMatched)

/**
 * @brief 正则匹配
 *
 * @param regex 正则表达式
 *
 * @return YES/NO(匹配/不匹配)
 *
 */
- (BOOL)pk_matchesRegex:(NSString *)regex;

/**
 * @brief 验证是否符合正则
 *
 * @param regex 正则表达式
 *
 * @return YES/NO(通过/未通过)
 *
 */
- (BOOL)pk_isValidByRegex:(NSString *)regex;

/** 验证是否为纯数字 */
- (BOOL)pk_isAllNumbers;

/** 验证是否纯汉字 */
- (BOOL)pk_isAllChineseCharacters;

/** 匹配邮箱格式是否正确 */
- (BOOL)pk_isValidEmailAddress;

/** 匹配邮政编码 */
- (BOOL)pk_isValidPostalCode;

/** 匹配手机号码格式【更新止2018年01月】*/
- (BOOL)pk_isValidMobileNumber;

/** 验证身份证格式是否正确 */
- (BOOL)pk_isValidIDCard;

/** 验证是否为身份证号 */
- (BOOL)pk_isValidIDCardNumber;

/** 验证是否为URL */
- (BOOL)pk_isValidURL;

@end
/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}    重复n次或更多次
 {n,m}   重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]    匹配除了x以外的任意字符
 [^aeiou]   匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?  重复n到m次，但尽可能少重复
 {n,}?   重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn    ASCII代码中八进制代码为nn的字符
 \xnn    ASCII代码中十六进制代码为nn的字符
 \unnnn  Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}   Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)    贪婪子表达式
 (?<x>-<y>exp)      平衡组
 (?im-nsx:exp)      在子表达式exp中改变处理选项
 (?im-nsx)          为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)        同上，只是使用空表达式作为no
 (?(name)yes|no)    如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)       同上，只是使用空表达式作为no
 
 捕获
 (exp)              匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)       匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)            匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)            匹配exp前面的位置
 (?<=exp)           匹配exp后面的位置
 (?!exp)            匹配后面跟的不是exp的位置
 (?<!exp)           匹配前面不是exp的位置
 注释
 (?#comment)        这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

NS_ASSUME_NONNULL_END
