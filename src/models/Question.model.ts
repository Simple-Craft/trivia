import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, AutoIncrement, Default, DataType, BelongsTo, ForeignKey } from "sequelize-typescript";
import Category from "./Category.model"
import User from "./User.model";

export enum ApprovalState {
    Pending,
    Approved,
    Rejected
}

export enum Difficulty {
    Easy,
    Medium,
    Hard,
    Impossible
}

export function stringToDifficulty(str: string) {
    let str_lower = str.toLowerCase()
    if (str_lower == "easy") return Difficulty.Easy
    else if (str_lower == "medium") return Difficulty.Medium
    else if (str_lower == "hard") return Difficulty.Hard
    else if (str_lower == "impossible") return Difficulty.Impossible
    else throw Error("Invalid difficulty string")
}

@Table
export default class Question extends Model<Question> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @ForeignKey(() => User)
    @Column
    submitterId: number;

    @BelongsTo(() => User)
    submitter: User;

    @Column(DataType.TEXT)
    question: string;

    @Column
    correctAnswer: string;

    @Column(DataType.TEXT)
    get wrongAnswers(): string[] {
        const json = this.getDataValue('wrongAnswers')
        // @ts-ignore
        return JSON.parse(json)
    }

    set wrongAnswers(value: string[]) {
        const json = JSON.stringify(value)
        // @ts-ignore
        this.setDataValue('wrongAnswers', json)
    }

    @ForeignKey(() => Category)
    @Column
    categoryId: number;

    @BelongsTo(() => Category)
    category: Category;

    @Default(Difficulty.Medium)
    @Column(DataType.SMALLINT)
    difficulty: Difficulty;

    @Default(false)
    @Column(DataType.TINYINT)
    approvalState: ApprovalState;

    @CreatedAt
    createdAt: Date;

    @UpdatedAt
    updatedAt: Date;
}